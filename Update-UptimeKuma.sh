docker stop Monitoring
docker rm Monitoring
docker run -d --restart=always -p 82:3001 -v /home/Docker/Monitoring:/app/data --name Monitoring louislam/uptime-kuma:latest
