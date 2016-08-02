#!/bin/sh

LOG_DIR=~/tmp/multi-build-logs
DEFAULT_REPEAT=20
REPEAT=$1
if [ -z "$REPEAT" ]
then
    REPEAT=$DEFAULT_REPEAT
fi
echo Running $REPEAT builds, outputing results to: $LOG_DIR

COUNTER=0
mkdir -p $LOG_DIR
while [  $COUNTER -lt $REPEAT ]; do
    mvn clean install -P backend > $LOG_DIR/mvn-$COUNTER.log 2>&1
    #mvn -U clean install > $LOG_DIR/mvn-$COUNTER.log 2>&1
    if [ $? -eq 0 ]; then
        echo Run $COUNTER: Success
        touch $LOG_DIR/mvn-$COUNTER.success
    else
        echo Run $COUNTER: FAILURE
        touch $LOG_DIR/mvn-$COUNTER.failure
    fi

    let COUNTER=COUNTER+1 
done
