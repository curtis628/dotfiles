#!/bin/sh

symphonyURI=http://10.0.0.151
#symphonyURI=http://symphony-be.eng.vmware.com
email="tyler@gmail.com"
password="password"
firstName="Tyler"
lastName="Curtis"
teamName="TylerTeam"
awsName="SomeAccount"
awsPrivateKeyId="AKIAIZV3NWMRSJBOKB4Q"
awsPrivateKey="kRvwuIeROBE7tG90xCE0XZbHo5GVnJw6BhO7Gu0V"
regionId="us-east-1"

jsonContent="Content-Type: application/json"

printf "Creating user: $email\n"
curl -H "$jsonContent" $symphonyURI/mgmt/user-onboarding --data "
    {\"email\":\"$email\",
     \"password\":\"$password\",
     \"firstName\":\"$firstName\",
     \"lastName\":\"$lastName\"
    }"
if [ $? -ne 0 ] ; then echo "Failed to onboard $email user..." & exit 1; fi

printf "\n\nAuthenticating with user: $email\n"
export auth=`curl --stderr - --verbose --user $email:$password -H "$jsonContent" $symphonyURI/authn/basic --data '{"requestType":"LOGIN"}' | grep x-xenon-auth-token | awk '{print $2, $3}'`

if [ -z "$auth" ]
then
    printf "\nError getting auth token!"
    exit 1
fi
printf "Got auth token: $auth\n"

printf "\nCreating organization: $teamName\n"
curl --silent -H "$jsonContent" -H "$auth" $symphonyURI/mgmt/org-onboarding --data "{\"organizationName\": \"$teamName\", \"requestType\": \"CREATE\"}"
if [ $? -ne 0 ] ; then echo "Failed to create $teamName org" & exit 1; fi

orgLink=`curl --silent -H "$auth" $symphonyURI/mgmt/user-context-query | jq .organizationSet[0].documentSelfLink`
if [ -z "$orgLink" ] ; then echo "Failed to find organizationLink for: $teamName" & exit 1; fi
printf "\n\nCreating project for organization: $orgLink\n"
curl -H "$auth" $symphonyURI/mgmt/projects --data "{\"projectName\":\"$teamName\",\"organizationLink\":$orgLink,\"requestType\":\"CREATE\"}"

printf "\n\nGetting resource pools for tenant: $teamName\n"
resourcePoolLink=`curl -H "$auth" "$symphonyURI/resources/pools" | jq .documentLinks[0]`

printf "\nConnecting AWS Account: $awsName\n"
curl -H "$jsonContent" -H "$auth" $symphonyURI/mgmt/aws-infra-config --data "
    {\"name\":\"$awsName\",
     \"privateKeyId\":\"$awsPrivateKeyId\",
     \"privateKey\":\"$awsPrivateKey\",
     \"environmentName\":\"Amazon Web Services\",
     \"resourcePoolLink\":$resourcePoolLink,
     \"regionId\":\"$regionId\",
     \"refreshIntervalMillis\":300000,
     \"showMarketPlace\":true
    }"

printf "\n\nDone!\n"
