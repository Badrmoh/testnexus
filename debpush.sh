#!/bin/bash

docker-compose exec apthost apt update -y
docker-compose exec apthost apt install -y curl

docker-compose exec apthost curl -v -u "admin:admin" -H "Content-Type: multipart/form-data" --data-binary "@./etc/apt/freeram_1.0-1.deb" "http://nexus:8081/repository/apt-devs/"
