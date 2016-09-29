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
# Password can be an user input instead of a parameter in the script with the read command. I would recommend also trying to login with the username:password to the platform before executing the docker run below.
# read -sp 'Anypoint Platform Password: ' password
orgName=$4
envName=$5
httpPort=$6
httpsPort=$7

## Create a random name
if [ "$(uname)" == "Darwin" ]; then
    # Mac OS X platform detected
    containerName=mule-$version-$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # GNU/Linux platform detected
    containerName=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-8} | head -n 1)
fi

echo "Starting new mule container: "$containerName

docker run -i -t --rm \
  --name $containerName \
  -p $httpPort:8081 \
  -p $httpsPort:8091 \
	knyc/mule-ee:$version \
	$username $password $orgName $envName $containerName-$httpPort-$httpsPort
