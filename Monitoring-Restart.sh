CTID="e98ce160983c"

if [[ "$DockerStop" = "$CTID" ]]; then
  sleep 10
  DockerStart=`docker start e98ce160983c`
  if [[ "$DockerStart" = "$CTID" ]]; then
    DockerStart=`docker start e98ce160983c`
    Datum=`date +%d.%m.%Y`
    Zeit=`date +%H:%M`
    echo "Erfolgreicher Monitor Restart am $Datum um $Zeit Uhr" | mail -s "Erfolgreich: Monitor Restart" etienne@elansing.de
  else
    Datum=`date +%d.%m.%Y`
    Zeit=`date +%H:%M`
    echo "Fehlgeschlagener Monitor Restart am $Datum um $Zeit Uhr" | mail -s "Fehlgeschlagen: Monitor Restart" etienne@elansing.de
  fi
else
  Datum=`date +%d.%m.%Y`
  Zeit=`date +%H:%M`
  echo "Fehlgeschlagener Monitor Restart am $Datum um $Zeit Uhr" | mail -s "Fehlgeschlagen: Monitor Restart" etienne@elansing.de
fi
