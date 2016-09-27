#!/bin/bash

if [ $# -ne 7 ]
  then
    echo "Invalid number of arguments: "
    echo "usage: ./startDockerContainer <version> <username> <password> <orgName> <envName> <httpPort> <httpsPort>"
    exit 1
fi

version=$1
username=$2
password=$3
orgName=$4
envName=$5
httpPort=$6
httpsPort=$7

## Create a random name
#On Linux

#containerName=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-8} | head -n 1)
#On Mac
containerName=mule-$version-$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)

echo "Starting new mule container: "$containerName

sudo docker run -i -t --rm \
  --name $containerName \
  -p $httpPort:8081 \
  -p $httpsPort:8091 \
	knyc/mule-ee:$version \
	$username $password $orgName $envName $containerName-$httpPort-$httpsPort
