#!/bin/bash

test -n "$1" && (
    echo MONGO_VERSION=\"$(docker exec -t $1 mongod --version | grep -e 'db version' | awk '{ print $3 }' | tr -d 'v\r')\"
    echo DEBIAN_VERSION=\"$(docker exec -t $1 grep VERSION= /etc/os-release|awk '{ print $2 }' | tr -d '()"\r')\"
) | tee env.properties || (
    echo Give container name as parameter!
    exit 1
)

