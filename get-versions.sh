#!/bin/bash

VERSIONS=version.properties

test -n "$1" && (
  echo MONGO_VERSION=\"$(docker exec -t $1 mongod --version | grep -e 'db version' | awk '{ print $3 }' | tr -d 'v\r')\" | tee -a $VERSIONS

  OS_ID=$(docker exec -t $1 cat /etc/os-release | grep -G ^ID= | awk -F= '{ print $2 }' | tr -d '\r')
  OS_VERSION_ID=$(docker exec -t $1 cat /etc/os-release | grep -G VERSION_ID= | awk -F= '{ print $2 }' | tr -d '"\r')
  echo OS_VERSION=\"${OS_ID}-${OS_VERSION_ID}\" | tee -a $VERSIONS
) | tee env.properties || (
  echo Give container name as parameter!
  exit 1
)
