docker run -d --name=Omada-Controller \
-e PUID=0 \
-e PGID=0 \
-e TZ=Europe/Bucharest \
-e MANAGE_HTTP_PORT=8088 \
-e MANAGE_HTTPS_PORT=8043 \
-e PORTAL_HTTP_PORT=8088 \
-e PORTAL_HTTPS_PORT=8043 \
-e SHOW_SERVER_LOGS=true \
-e SHOW_MONGODB_LOGS=false \
-e SSL_CERT_NAME="tls.crt" \
-e SSL_KEY_NAME="tls.key" \
-v /home/Docker/Omada/data:/opt/tplink/EAPController/data \
-v /home/Docker/Omada/logs:/opt/tplink/EAPController/logs \
-v /home/Docker/Omada/work:/opt/tplink/EAPController/work \
--net host \
--restart always \
mbentley/omada-controller
