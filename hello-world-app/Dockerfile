###############################################################################
## Dockerizing Hello World App on Mule EE
## Version:  1.0
## Deployed on:  knyc/mule-ee:3.8.1
###############################################################################

FROM                    knyc/mule-ee:3.8.1
MAINTAINER              Ken Ng <ken.ng@mulesoft.com>

## Install Mule EE
WORKDIR /opt/mule
COPY    ./hello-world.zip /opt/mule/apps/hello-world.zip

###############################################################################
## Configure mule runtime access pre-requisites

## HTTPS Port for Anypoint Platform communication
EXPOSE  443

## Mule remote debugger
EXPOSE  5000

## Mule JMX port (must match Mule config file)
EXPOSE  1098

## Mule Cluster ports
EXPOSE 5701
EXPOSE 54327

###############################################################################
## Expose the necessary port ranges as required by the apps to be deployed

## HTTP Service Port
EXPOSE 8081

###############################################################################

## Environment and execution:
ENV             MULE_BASE /opt/mule
WORKDIR         /opt/mule/bin
ENTRYPOINT      ["/opt/mule/bin/startMule.sh"]
