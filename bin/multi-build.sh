#!/bin/sh
LOG_DIR=~/tmp/multi-build-logs
DEFAULT_REPEAT=20

help() {
    SCRIPT=`basename "$0"`
    USAGE="$SCRIPT [repeat] [mvn_opts] \n\
    Optional Options: \n\
      repeat     - number of times to repeat 'mvn' build. Default: $DEFAULT_REPEAT
      mvn_opts   - any custom options to pass to 'mvn' build\n"
    printf "$USAGE"
    exit 0
}

if [ "${1}" == "--help" ]
then
    help
fi
REPEAT=${1:-$DEFAULT_REPEAT}
MVN_OPTS=${2:-""}

echo Running $REPEAT test builds with [options=$MVN_OPTS], outputing results to: $LOG_DIR
COUNTER=0
rm -rf $LOG_DIR/*
mkdir -p $LOG_DIR
for i in $(seq -w $REPEAT); do
    mvn -U -B -s tools/build/maven-settings.xml test $MVN_OPTS > $LOG_DIR/mvn-$i.log 2>&1
    [[ $? = 0 ]] && status="Success" || status="FAILURE"
    echo Run $i: $status
    mv $LOG_DIR/mvn-$i.log $LOG_DIR/mvn-$i.$status.log
done
