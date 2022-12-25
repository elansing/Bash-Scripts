docker stop Bitwarden
docker rm Bitwarden
docker pull vaultwarden/server:latest
docker run -d --name Bitwarden -v /home/Docker/Bitwarden/:/data/ -p 81:80 -p 3012:3012 vaultwarden/server:latest
rm Update-Bitwarden.sh
