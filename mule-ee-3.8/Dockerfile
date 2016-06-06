# Dockerizing Mule EE
# Version:  1.0
# Based on:  java:8-jre (Trusted Java from http://java.com)

FROM                    java:8-jre
MAINTAINER              Ken Ng <ken.ng@mulesoft.com>

# MuleEE installation:

# Install Mule EE
COPY                    ./mule-ee-distribution-standalone-3.8.0.tar.gz /opt/
WORKDIR                 /opt
RUN                     echo "031c32f2dff1add94d989eb402aded9e mule-ee-distribution-standalone-3.8.0.tar.gz" | md5sum -c
RUN                     tar -xzvf /opt/mule-ee-distribution-standalone-3.8.0.tar.gz
RUN                     ln -s mule-enterprise-standalone-3.8.0/ mule
RUN                     rm -f  mule-ee-distribution-standalone-3.8.0.tar.gz

# Copy the Datamapper plugin
WORKDIR                 /opt/mule-enterprise-standalone-3.8.0
ADD                     ./data-mapper-plugin-3.8.0.zip /opt/mule-enterprise-standalone-3.8.0/plugins/

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

# Mule HTTPS port
EXPOSE  443

# Environment and execution:

ENV             MULE_BASE /opt/mule
WORKDIR         /opt/mule-enterprise-standalone-3.8.0
CMD             ./bin/mule
