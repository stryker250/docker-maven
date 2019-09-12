#!/bin/bash

WHOAMI=`whoami`

SUDO=sudo

if [ $WHOAMI == "root" ]; then
  SUDO=""
fi

TAG=$1
PUSH=$2
REGISTRY=$3
NAME=docker-maven

if [ -z $TAG ]; then
  echo "No tag provded. Please provide a tag"
  exit 1
fi

if [ -z $PUSH ]; then
  echo "Not pushing to Docker registry."
  PUSH=0
fi

if [ $PUSH == 1 ]; then
  if [ -z $REGISTRY ]; then
    echo "Using Local Registry"
    REGISTRY=registry.imisglobal.com:50000/
  elif [ "$REGISTRY" == "docker" ]; then
    echo "Using Docker Hub Registry"
    REGISTRY=""
  else
    echo "Using Local Registry"
    REGISTRY=registry.imisglobal.com:50000/
  fi
fi

$SUDO docker build -t $NAME:$TAG .

if [ $PUSH == 1 ]; then
  $SUDO docker tag $NAME:$TAG $REGISTRY$NAME:$TAG
  $SUDO docker push $REGISTRY$NAME:$TAG
fi
