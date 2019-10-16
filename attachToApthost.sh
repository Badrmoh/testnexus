#!/bin/bash

cd $PWD
docker-compose ps apthost > /dev/null
x=$(echo $?)
if [ $x -eq 0 ];then
    docker-compose exec apthost bash
fi
