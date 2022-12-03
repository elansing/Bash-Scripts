mkdir /home/Docker/NPM
docker run -d \
    --name=Nginx-Proxy-Manager \
    -p 81:8181 \
    -p 80:8080 \
    -p 443:4443 \
    -v /home/Docker/NPM:/config:rw \
    jlesage/nginx-proxy-manager