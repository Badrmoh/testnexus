#!/bin/bash

cd $PWD
docker-compose ps yumhost > /dev/null
x=$(echo $?)
if [ $x -eq 0 ];then
    docker-compose exec yumhost bash
fi
