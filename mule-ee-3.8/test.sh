#!/bin/bash
serverName=mule-3.8.1-GBLTnYPB-8083-8093

serverData=$(curl -X "GET" "https://anypoint.mulesoft.com/hybrid/api/v1/servers/" -H "X-ANYPNT-ORG-ID: d2983a9b-bcdf-4431-88d0-ce04916f9d4c" -H "X-ANYPNT-ENV-ID: 2dc6c350-b783-43c0-8b0e-23ab3b621e24" -H "Authorization: Bearer 0bfef85d-0180-42b6-a53a-ed432eaf4ba5")

jqParam=".data[] | select(.name==\"$serverName\").id"
serverId=$(echo $serverData | jq --raw-output "$jqParam")
echo "ServerId $serverName: $serverId"

jqParam=".data[] | select(.name==\"$serverName\").clusterId"
clusterId=$(echo $serverData | jq --raw-output "$jqParam")
if [ "$clusterId" != "" ]
  then
    echo "$serverName is found in cluster ID: $clusterId"
fi
