#!/bin/sh

COUNTER=0
while [  $COUNTER -lt 30 ]; do
    mvn clean install > ~/tmp/appMigrationLogs/mvn-$COUNTER.log 2>&1
    if [ $? -eq 0 ]; then
        echo Success
        touch ~/tmp/appMigrationLogs/mvn-$COUNTER.success
    else
        echo FAILED!
        touch ~/tmp/appMigrationLogs/mvn-$COUNTER.failure
    fi

    let COUNTER=COUNTER+1 
done
