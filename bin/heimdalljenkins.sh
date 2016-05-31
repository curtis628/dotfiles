#!/bin/bash

# Set the docker variables
eval $(docker-machine env default)

# Set a dummy build number
export BUILD_NUMBER=10

# Set WORKSPACE as path to heimdall
export WORKSPACE=~/workspace/heimdall

# Start the job from root of heimdall giving the IP of the docker host
export DHOST=$(docker-machine ip default)
$WORKSPACE/build-resources/jenkins-build.sh $DHOST
