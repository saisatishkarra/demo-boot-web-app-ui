#!/bin/bash

usage() {
    echo "$0 \"DOMAINS <space separated domain/ip,url,email with quoutes>\" tomcat_ssl_port"
    exit 1
}

DOMAIN="$1"
PORT=$2

if [[ -z $DOMAIN ]]; then
    usage
fi

if [[ -z $PORT ]]; then
    PORT=443
fi

rm -Rf mkcert

git clone https://github.com/FiloSottile/mkcert && cd mkcert
go build -ldflags "-X main.Version=$(git describe --tags)"

./mkcert -pkcs12 -p12-file ../src/main/resources/vue.p12 $DOMAIN

echo "CA Root certificate for client trustStore: $(./mkcert -CAROOT)/rootCA.pem" 

cd ..
./mvnw clean install

java -Dserver.port=$PORT -Dserver.ssl.key-store=classpath:vue.p12 -Dserver.ssl.key-store-password=changeit -jar target/demo-boot-1.0-RELEASE.jar
