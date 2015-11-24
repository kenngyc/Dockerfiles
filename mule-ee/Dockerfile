# Dockerizing Mule EE
# Version:  1.0
# Based on:  java:8-jre (Trusted Java from http://java.com)

FROM                    java:8-jre
MAINTAINER              Ken Ng <ken.ng@mulesoft.com>

# MuleEE installation:

# Install Mule EE
COPY                    ./mule-ee-distribution-standalone-3.7.2.tar.gz /opt/
WORKDIR                 /opt
RUN                     echo "a4d03963f28c4ba0741365e79ea54dfb mule-ee-distribution-standalone-3.7.2.tar.gz" | md5sum -c
RUN                     tar -xzvf /opt/mule-ee-distribution-standalone-3.7.2.tar.gz
RUN                     ln -s mule-enterprise-standalone-3.7.2/ mule
RUN                     rm -f  mule-ee-distribution-standalone-3.7.2.tar.gz

# Uncomment if you want to copy and install the license
# Take note the name of the license file name
#WORKDIR                 /opt/mule-enterprise-standalone-3.7.2
#ADD                     ./mule-ee-license.lic /opt/mule-enterprise-standalone-3.7.2/conf/
#RUN                     bin/mule -installLicense conf/mule-ee-license.lic
#RUN                     rm -f conf/mule-ee-license.lic

# Copy the Datamapper plugin
WORKDIR                 /opt/mule-enterprise-standalone-3.7.2
ADD                     ./data-mapper-plugin-3.7.2.zip /opt/mule-enterprise-standalone-3.7.2/plugins/

# Install Mule Agent 1.2.0
WORKDIR                 /opt
COPY                    ./mule-agent-1.2.0.tar.gz /opt/
RUN                     tar -xzvf /opt/mule-agent-1.2.0.tar.gz
RUN                     cp /opt/mule-agent-1.2.0/agent-setup-1.2.0-amc-final.jar /opt/mule-enterprise-standalone-3.7.2/tools
RUN                     rm /opt/mule-enterprise-standalone-3.7.2/bin/amc_setup
RUN                     cp /opt/mule-agent-1.2.0/amc_setup /opt/mule-enterprise-standalone-3.7.2/bin
RUN                     rm /opt/mule-agent-1.2.0.tar.gz

# Run AMC Setup
# WORKDIR                 /opt/mule-enterprise-standalone-3.7.2/bin/
# RUN                     ./amc_setup -A http://52.74.225.250:8080/hybrid/api/v1 -W "wss://52.74.225.250:8443/mule" -F https://52.74.225.250/apiplatform -C https://52.74.225.250/accounts -H 61aa89ba-611a-449a-af83-f13921cee831---2 MULE-$HOSTNAME

# Configure external access:

# HTTP Service Port
# Expose the necessary port ranges as required by the Mule Apps
EXPOSE 8081-8082

# Mule remote debugger
EXPOSE  5000

# Mule JMX port (must match Mule config file)
EXPOSE  1098

# Mule MMC agent port
EXPOSE  7777

# Environment and execution:

ENV             MULE_BASE /opt/mule
WORKDIR         /opt/mule-enterprise-standalone-3.7.2
CMD             /bin/mule
