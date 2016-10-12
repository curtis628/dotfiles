#!/bin/sh -vx

cd ~/workspace/symphony
#mvn clean install -P backend -DskipTests
mvn clean install -DskipTests
if [ $? -ne 0 ] ; then exit 1; fi

make docker-local
