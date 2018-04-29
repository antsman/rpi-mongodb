#!/bin/bash

# $1 container name, $2 mongo version

if [ -z $1 ]; then
    CONTAINER_NAME=rpi-mongodb-build
else
    CONTAINER_NAME=$1
fi
    
if [ -z $2 ]; then
    MONGO_VERSION=3.2.19
else
    MONGO_VERSION=$2
fi

#docker exec -ti --workdir /mongodb-src-r$MONGO_VERSION $CONTAINER_NAME sh -c "
docker exec -ti $CONTAINER_NAME sh -c "
    set -e
    ls -l
    cd /mongodb-src-r$MONGO_VERSION
# For Mozilla virtualenv .. Exception: Could not detect environment shell!
    export SHELL=/bin/sh
# Build
    scons mongod -j 2 --max-drift=1 --implicit-deps-unchanged --wiredtiger=off --mmapv1=on
# Test
    cd build/opt/mongo
    ls -l
    strip -s mongo
    ls -l
    ./mongo --version
    ./mongod --version
"

