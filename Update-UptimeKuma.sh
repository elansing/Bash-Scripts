docker stop Monitoring
docker rm Monitoring
docker pull louislam/uptime-kuma
docker run -d --restart=always -p 82:3001 -v /home/Docker/Monitoring:/app/data --name Monitoring louislam/uptime-kuma:latest
rm Update-UptimeKuma.sh
