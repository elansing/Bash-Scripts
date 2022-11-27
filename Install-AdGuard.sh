curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v
/opt/AdGuardHome/AdGuardHome -s start
echo AdGuard ist nun über den Initialport 3000 erreichbar
