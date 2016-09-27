#!/bin/bash

hybridAPI=https://anypoint.mulesoft.com/hybrid/api/v1
accAPI=https://anypoint.mulesoft.com/accounts

username=$1
password=$2
orgName=$3
envName=$4
serverName=$5

# Authenticate with user credentials (Note the APIs will NOT authorize for tokens received from the OAuth call. A user credentials is essential)
echo "Getting access token from $accAPI/login..."
accessToken=$(curl -s $accAPI/login -X POST -d "username=$username&password=$password" | jq --raw-output .access_token)
echo "Access Token: $accessToken"

# Pull org id from my profile info
echo "Getting org ID from $accAPI/api/me..."
jqParam=".user.contributorOfOrganizations[] | select(.name==\"$orgName\").id"
orgId=$(curl -s $accAPI/api/me -H "Authorization:Bearer $accessToken" | jq --raw-output "$jqParam")
echo "Organization ID: $orgId"

# Pull env id from matching env name
echo "Getting env ID from $accAPI/api/organizations/$orgId/environments..."
jqParam=".data[] | select(.name==\"$envName\").id"
envId=$(curl -s $accAPI/api/organizations/$orgId/environments -H "Authorization:Bearer $accessToken" | jq --raw-output "$jqParam")
echo "Environment ID: $envId"

# Request amc token
echo "Getting registrion token from $hybridAPI/servers/registrationToken..."
amcToken=$(curl -s $hybridAPI/servers/registrationToken -H "X-ANYPNT-ENV-ID:$envId" -H "X-ANYPNT-ORG-ID:$orgId" -H "Authorization:Bearer $accessToken" | jq --raw-output .data)
echo "AMC Token: $amcToken"

# Register new mule
echo "Registering $serverName to Anypoint Platform..."
./amc_setup -H "$amcToken" $serverName

# Start mule!
./mule

echo "De-registering $serverName from Anypoint Platform..."

# Get Server ID from AMC
echo "Getting server ID from $hybridAPI/servers..."
jqParam=".data[] | select(.name==\"$serverName\").id"
serverId=$(curl -s $hybridAPI/servers/ -H "X-ANYPNT-ENV-ID:$envId" -H "X-ANYPNT-ORG-ID:$orgId" -H "Authorization:Bearer $accessToken" | jq --raw-output "$jqParam")
echo "ServerID $serverName: $serverId"

# Deregister mule from ARM
echo "Deregistering Server at $hybridAPI/servers/$serverId..."
curl -X "DELETE" "$hybridAPI/servers/$serverId" -H "X-ANYPNT-ENV-ID:$envId" -H "X-ANYPNT-ORG-ID:$orgId" -H "Authorization:Bearer $accessToken"

echo "Everything looks clean now."
echo "Live long and prosper."
