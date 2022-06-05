CTID="Monitoring"

DockerStop=`docker stop Monitoring`
if [[ "$DockerStop" = "$CTID" ]]; then
  sleep 10
  DockerStart=`docker start Monitoring`
  if [[ "$DockerStart" = "$CTID" ]]; then
    DockerStart=`docker start Monitoring`
    Datum=`date +%d.%m.%Y`
    Zeit=`date +%H:%M`
    echo "Erfolgreicher Monitor Restart am $Datum um $Zeit Uhr" | mail -s "Erfolgreich: Monitor Restart" ZapHosting-VPS1@elansing.de
  else
    Datum=`date +%d.%m.%Y`
    Zeit=`date +%H:%M`
    echo "Fehlgeschlagener Monitor Restart am $Datum um $Zeit Uhr" | mail -s "Fehlgeschlagen: Monitor Restart" ZapHosting-VPS1@elansing.de
  fi
else
  Datum=`date +%d.%m.%Y`
  Zeit=`date +%H:%M`
  echo "Fehlgeschlagener Monitor Restart am $Datum um $Zeit Uhr" | mail -s "Fehlgeschlagen: Monitor Restart" ZapHosting-VPS1@elansing.de
fi
