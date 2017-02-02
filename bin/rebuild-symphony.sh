#!/bin/sh -vx

cd ~/workspace/symphony
mvn clean install -P backend -DskipTests
#mvn clean install -DskipTests
#mvn clean install
if [ $? -ne 0 ] ; then exit 1; fi

make docker-local

# Helpful for testing upgrade
docker tag symphony-docker-local.jfrog.io/symphony/symphony:custom symphony-docker-local.jfrog.io/symphony/symphony:custom2
