#!/bin/bash

docker-compose exec yumhost curl -v -u admin:admin --upload-file /etc/yum.repo.d/vault.rpm http://nexus:8081/repository/prod-yum/kunde3/vault.rpm
