# Dockerizing API Gateway
# Version:  1.0
# Based on:  java:8-jre (Trusted Java from http://java.com)

FROM                    java:8-jre
MAINTAINER              Ken Ng <ken.ng@mulesoft.com>

# API Gateway installation:

# Install API Gateway EE
COPY                    ./api-gateway-standalone-2.1.0.tar.gz /opt/
WORKDIR                 /opt
RUN                     echo "5a618973fb03b7b8f1f7fcb690f98ada api-gateway-standalone-2.1.0.tar.gz" | md5sum -c
RUN                     tar -xzvf /opt/api-gateway-standalone-2.1.0.tar.gz
RUN                     ln -s api-gateway-standalone-2.1.0/ apigw
RUN                     rm -f  api-gateway-standalone-2.1.0.tar.gz

# Uncomment if you want to copy and install the license
# Take note the name of the license file name
#WORKDIR                 /opt/api-gateway-standalone-2.1.0
#ADD                     ./apigw-ee-license.lic /opt/api-gateway-standalone-2.1.0/conf/
#RUN                     bin/gateway -installLicense conf/apigw-ee-license.lic
#RUN                     rm -f conf/apigw-ee-license.lic

# Copy the Datamapper plugin
WORKDIR                 /opt/api-gateway-standalone-2.1.0
ADD                     ./data-mapper-plugin-3.7.2.zip /opt/api-gateway-standalone-2.1.0/plugins/

# Install Mule Agent 1.2.0
WORKDIR                 /opt
COPY                    ./mule-agent-1.2.0.tar.gz /opt/
RUN                     tar -xzvf /opt/mule-agent-1.2.0.tar.gz
RUN                     cp /opt/mule-agent-1.2.0/agent-setup-1.2.0-amc-final.jar /opt/api-gateway-standalone-2.1.0/tools
RUN                     rm /opt/api-gateway-standalone-2.1.0/bin/amc_setup
RUN                     cp /opt/mule-agent-1.2.0/amc_setup /opt/api-gateway-standalone-2.1.0/bin
RUN                     rm /opt/mule-agent-1.2.0.tar.gz

# Configure external access:

# HTTP Service Port
# Expose the necessary port ranges as required by the API Gateway
EXPOSE 8081-8082

# Mule remote debugger
EXPOSE  5000

# Mule JMX port (must match Mule config file)
EXPOSE  1098

# Mule MMC agent port
EXPOSE  7777

# Environment and execution:
ENV             MULE_BASE /opt/apigw
WORKDIR         /opt/api-gateway-standalone-2.1.0
CMD             /bin/gateway
