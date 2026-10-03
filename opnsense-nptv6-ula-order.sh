#!/bin/sh
#
# FW01 (OPNsense): NPTv6 nach dem Boot reparieren (ToDo 39).
#
# Problem: Die NPTv6-Regel wird zu `binat ... -> (vlan0.40:0)` und nimmt damit
# die ERSTE IPv6-Adresse von vlan0.40. Nach dem Boot steht die Gateway-ULA
# (fd9b:d169:9a9f:40::1) vor der Provider-Adresse (2003:...), die Regel
# "uebersetzt" dann fd9b auf fd9b und IPv6 nach aussen geht nicht mehr.
#
# Loesung: Warten, bis die Provider-Adresse da ist, dann die ULA entfernen und
# neu setzen (neue Adressen landen hinten in der Liste), danach die Filterregeln
# neu laden. Das Skript ist idempotent: steht die Provider-Adresse schon vorn,
# passiert nichts.
#
# Installation auf FW01 (als root):
#   cp 50-nptv6-ula-order.sh /usr/local/etc/rc.syshook.d/start/50-nptv6-ula-order
#   chmod 755 /usr/local/etc/rc.syshook.d/start/50-nptv6-ula-order
#
# Manuell / per Cron (ohne Warteschleife, z. B. nach einem Praefixwechsel):
#   /usr/local/etc/rc.syshook.d/start/50-nptv6-ula-order once
#
# Log: `grep nptv6-fix /var/log/system/latest.log` bzw. System > Log-Dateien.
# Nach Major-Upgates pruefen, ob das Skript noch unter rc.syshook.d/start liegt.

IFACE="vlan0.40"
ULA="fd9b:d169:9a9f:40::1"
PROVIDER_PREFIX="2003:"
MAX_WAIT=600   # Sekunden, nur im Boot-Modus
TAG="nptv6-fix"

log() {
    /usr/bin/logger -t "$TAG" "$1"
}

# Erste globale (nicht link-lokale) IPv6-Adresse des Interfaces.
first_global() {
    /sbin/ifconfig "$IFACE" 2>/dev/null | /usr/bin/awk '$1 == "inet6" && $2 !~ /^fe80/ { print $2; exit }'
}

has_provider_address() {
    /sbin/ifconfig "$IFACE" 2>/dev/null | /usr/bin/awk -v p="$PROVIDER_PREFIX" '$1 == "inet6" && index($2, p) == 1 { found = 1 } END { exit !found }'
}

fix() {
    first="$(first_global)"
    if [ -z "$first" ]; then
        log "keine globale IPv6-Adresse auf $IFACE - nichts zu tun"
        return 1
    fi
    if [ "$first" != "$ULA" ]; then
        log "Reihenfolge ok (erste Adresse: $first)"
        return 0
    fi

    prefixlen="$(/sbin/ifconfig "$IFACE" | /usr/bin/awk -v a="$ULA" '$1 == "inet6" && $2 == a { for (i = 1; i <= NF; i++) if ($i == "prefixlen") print $(i + 1) }')"
    [ -z "$prefixlen" ] && prefixlen=64

    log "ULA $ULA steht vor der Provider-Adresse - setze sie neu (prefixlen $prefixlen)"
    /sbin/ifconfig "$IFACE" inet6 "$ULA" delete || { log "ULA entfernen fehlgeschlagen"; return 1; }
    /sbin/ifconfig "$IFACE" inet6 "$ULA" prefixlen "$prefixlen" alias || { log "ULA setzen fehlgeschlagen"; return 1; }

    first="$(first_global)"
    if [ "$first" = "$ULA" ]; then
        log "WARNUNG: ULA steht nach dem Neusetzen weiterhin vorn ($first)"
        return 1
    fi

    /usr/local/sbin/configctl filter reload >/dev/null 2>&1
    log "fertig - erste Adresse jetzt $first, Filterregeln neu geladen"
    return 0
}

if [ "$1" = "once" ]; then
    fix
    exit $?
fi

# Boot-Modus: im Hintergrund warten, damit der Boot nicht blockiert.
(
    waited=0
    while [ "$waited" -lt "$MAX_WAIT" ]; do
        if has_provider_address; then
            # Kurz warten, damit weitere Adressen/Router-Advertisements durch sind.
            sleep 5
            fix
            exit $?
        fi
        sleep 5
        waited=$((waited + 5))
    done
    log "Provider-Adresse ($PROVIDER_PREFIX...) auf $IFACE nach ${MAX_WAIT}s nicht erschienen - abgebrochen"
) >/dev/null 2>&1 &

exit 0
