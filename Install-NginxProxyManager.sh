mkdir /home/Docker/NPM
docker run -d \
    --name=Nginx-Proxy-Manager \
    -p 82:8181 \
    -p 80:8080 \
    -p 443:4443 \
    -v /home/Docker/NPM:/config:rw \
    jlesage/nginx-proxy-manager

echo Der Nginx-Proxy-Manager ist nun installiert und kann über den Port 81 erreicht werden. Die default Daten sind: Mail:admin@example.com PW:changeme