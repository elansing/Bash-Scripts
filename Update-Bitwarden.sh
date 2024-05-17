docker stop Bitwarden
docker rm Bitwarden
docker pull vaultwarden/server:latest
docker run -d -p 81:80 -p 3012:3012 \
    --name=Bitwarden --restart=always \
    -v /home/Docker/Bitwarden/:/data/ \
    vaultwarden/server:latest
rm Update-Bitwarden.sh
