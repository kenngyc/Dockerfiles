#!/bin/bash

if [ $# -ne 6 ]
  then
    echo "Invalid number of arguments: "
    echo "usage: ./startHelloWorldContainer <version> <username> <password> <orgName> <envName> <httpPort>"
    exit 1
fi

appName="hello-world"
version=$1
username=$2
password=$3
# Password can be an user input instead of a parameter in the script with the read command. I would recommend also trying to login with the username:password to the platform before executing the docker run below.
# read -sp 'Anypoint Platform Password: ' password
orgName=$4
envName=$5
httpPort=$6

## Create a random name
if [ "$(uname)" == "Darwin" ]; then
    # Mac OS X platform detected
    containerName=$appName-$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # GNU/Linux platform detected
    containerName=$appName-$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
fi

echo "Starting new mule container: "$containerName

docker run -i -t --rm \
  --name $containerName \
  -p $httpPort:8081 \
	knyc/hello-world-app:$version \
	$username $password $orgName $envName $containerName-$httpPort
