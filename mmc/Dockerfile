# Dockerizing Mule Management Console
# Version:  1.0
# Based on:  tomcat:7 (From Tomcat Official Repository https://hub.docker.com/_/tomcat/)

FROM                    tomcat:7
MAINTAINER              Ken Ng <ken.ng@mulesoft.com>

# MMC installation:

# Copy over MMC War to webapps directory
COPY                    ./mmc-console-3.8.0.war /usr/local/tomcat/webapps/mmc.war

# Configure external access:

# Expose the HTTP Ports
EXPOSE 8080
EXPOSE 443
EXPOSE 7777-7877

# Environment and execution:

ENV             CATALINA_HOME /usr/local/tomcat
ENV             PATH $CATALINA_HOME/bin:$PATH
WORKDIR         $CATALINA_HOME
CMD             ["catalina.sh", "run"]
