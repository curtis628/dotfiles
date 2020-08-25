#!/bin/sh
help() {
    SCRIPT=`basename "$0"`
    USAGE="$SCRIPT label [namespace] \n\
    Options: \n\
      label      - [REQUIRED] k8s label to download logs for
      namespace  - k8s namespace\n"
    printf "$USAGE"
    exit 0
}

if [ "${1}" == "--help" ]
then
    help
fi
LABEL=${1}
if [ -z "$LABEL" ]
then
    printf "\nPlease provide the k8s 'label' to use as the first argument.\n"
    exit 1
fi

NAMESPACE=${2:-"prelude"}
wait_sec=10

echo Downloading logs for pods with label:$LABEL and namespace:$NAMESPACE
pods=`kubectl get pods --namespace=$NAMESPACE -l $LABEL --output=name`

for pod_with_prefix in $pods
do
  pod=`echo $pod_with_prefix | cut -d'/' -f 2`
  echo Starting log download for $pod
  kubectl --namespace=$NAMESPACE logs $pod > $pod.log &
  kubectl --namespace=$NAMESPACE logs $pod --previous > $pod.previous.log &
done

jobs_output=initial
while [ -z "$jobs_output" ]
do
  jobs_output=`jobs`
  echo -e "\nAs of" `date` ": Running jobs include: "
  printf "%s\n" $jobs_output
  sleep $wait_sec
done

echo Download complete
