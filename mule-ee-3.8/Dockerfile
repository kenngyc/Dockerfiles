###############################################################################
## Dockerizing Mule EE
## Version:  1.0
## Based on:  java:8-jre (Trusted Java from http://java.com)
###############################################################################

FROM                    java:8-jre
MAINTAINER              Ken Ng <ken.ng@mulesoft.com>

###############################################################################
## Setting up the arguments
ARG     muleVersion=3.8.1
ARG     muleDistribution=mule-ee-distribution-standalone-$muleVersion.tar.gz
ARG     muleHome=/opt/mule-enterprise-standalone-$muleVersion

###############################################################################
## Base container configurations

# Configure instance timezone
RUN     echo 'Asia/Singapore' > /etc/timezone && dpkg-reconfigure tzdata

# Install base pre-requisites
RUN     apt-get update
RUN     apt-get upgrade --yes --force-yes
RUN     apt-get install --yes --force-yes apt-utils
RUN     apt-get install --yes --force-yes curl
RUN     apt-get install --yes --force-yes jq

###############################################################################
## MuleEE installation:

## Install Mule EE
WORKDIR /opt/
COPY    ./$muleDistribution /opt/
RUN     echo "3a49a52f360e5a7e139a654ed698a029 /opt/$muleDistribution" | md5sum -c
RUN     tar -xzvf /opt/$muleDistribution
RUN     ls
RUN     ln -s $muleHome/ mule
RUN     ls -l mule
RUN     rm -f $muleDistribution

## [OPTIONAL] Copy the Datamapper plugin
# ADD     ./data-mapper-plugin-$muleVersion.zip /opt/mule/plugins/

## Copy the License file - pre-package into docker image to avoid leakage
# ADD     ./mule-ee-license.lic /opt/mule/conf/
# RUN     /opt/mule/bin/mule -installLicense /opt/mule/conf/mule-ee-license.lic
# RUN     rm -f /opt/mule/conf/mule-ee-license.lic

## Copy the mule start/stop script
ADD     ./startMule.sh /opt/mule/bin/
RUN     chmod 755 /opt/mule/bin/startMule.sh

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

## HTTPS Service Port
EXPOSE 8091

###############################################################################

## Environment and execution:
ENV             MULE_BASE /opt/mule
WORKDIR         /opt/mule/bin
ENTRYPOINT      ["/opt/mule/bin/startMule.sh"]
