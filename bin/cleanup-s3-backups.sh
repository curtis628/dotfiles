#!/bin/sh

backup_regex=$2
if [ -z "$2" ]
then
    backup_regex="jenkins-.*-backup.*"
fi
echo Querying S3 for buckets matching: ${backup_regex}

if [ "$1" != "--force" ]
then
    echo ...Doing dry run. Run script with '--force' to actually remove these buckets
    run_cmd="echo "
else
    echo ...Forcing removal of matching S3 buckets.
    run_cmd="aws s3 rb --force s3://"
fi
echo Running this command for each matching bucket: ${run_cmd}
echo

for backup in $( aws s3 ls | grep --only-matching ${backup_regex} ); do
    ${run_cmd}${backup}
done
