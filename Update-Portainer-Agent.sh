docker stop PortainerAgent
docker rm PortainerAgent
docker pull portainer/agent:latest
docker run -d \
  -p 9001:9001 \
  --name PortainerAgent \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker/volumes:/var/lib/docker/volumes \
  portainer/agent:latest