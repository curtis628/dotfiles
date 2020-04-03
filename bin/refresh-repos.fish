#!/usr/local/bin/fish
set -l projects \
    heimdall \
    le-mans \
    ops-data-solr \
    ops-ingest \
    ops-mgmt-solr \
    symphony \
    symphony-infra

for project in $projects
    echo Refreshing $project
    cd $WORKSPACE/$project
    git checkout master
    git pull
    echo
end

echo Successfully refreshed all projects to latest
