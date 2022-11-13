mkdir /home/Docker
mkdir /home/Docker/Gucamole
docker run -d --name=guacamole \
-p 8348:8080 \
-e PUID=1026 \
-e PGID=100 \
-e TZ=Europe/Bucharest \
-v /home/Docker/Gucamole:/config \
--restart always \
jwetzell/guacamole
