# Dockerized Mule Runtime

*This is an evolution of my initial dockerization of Mule. Also credits to Nial's work on the automation script to auto-register Mule runtime using the Anypoint Platform's APIs that I've further extended to support a different POV on a dockerized Mule instance.*

## The Docker Image
This docker image is aimed to fully automate the lifecycle of a stateless Mule Runtime instance. This container and it's startup script will: -
- Starts up new Mule Runtime instance with a unique server and container name
- Auto-register itself to Anypoint Runtime Manager in the cloud.
- Auto-remove itself from the Anypoint Runtime Manager upon shutdown
- Cleanly remove itself from the Docker host machine

**Cluster support**

***Single host clustering***: This container supports the clustering of the Mule instances that are running on the same host and will safely remove itself from the Cluster before unregistering itself from Anypoint Runtime Manager.
The nodes can discover and communicate between each other within for the clustering.

Both multicast and unicast clustering configuration is supported.

> For Unicast clustering, Anypoint Runtime Manager triggers a restart on the cluster upon any changes on the cluster membership.

***Multi-host clustering***: This image however has not been tested for For clustering across different Docker host machines, I've not yet tested this scenario. The Dockerfile exposes port 5701 and port 54327 but the port is not mapped in the startDockerContainer.sh script.

### Using this Docker Image

I've uploaded the Docker image to Docker Hub (https://hub.docker.com/r/knyc/mule-ee/)

To run it, use the provided startDockerContainer.sh script. The format is self explanatory.

```sh
./startDockerContainer.sh <version> <username> <password> <orgName> <envName> <httpPort> <httpsPort>
```
1. ***version*** defines the version of Mule to be used. As for now, only 3.8.1 is available.
2. ***username*** and ***password*** is your Anypoint Platform's username and password. (_The script can be modified to request for the password to be typed in on every run with the **read** command._)
3. ***orgName*** is the name of the Organization where you want your Mule intances to be registered to.
4. ***envName*** is the target environment of the selected Organization.
5. ***httpPort*** is the external HTTP service port that you want to be mapped to the internal port 8081.
6. ***httpsPort*** is the external HTTPS service port that you want to be mapped to the internal port 8091.

[*Credits to Nial for the initial work on this script. Slightly modified for my iteration here.*]

##### Key points to note on the startDockerContainer.sh script

Name formats:
- Docker container name format:  ***mule-[version]-[8-random-alpahnumeric-characters]***
- Mule server name format: ***mule-[version]-[8-random-alpahnumeric-characters]-[http-port]-[https-port]***

###### Container name generator
The following part of the script shows you how the name is generated.
```sh
## Create a random name
if [ "$(uname)" == "Darwin" ]; then
    # Mac OS X platform detected
    containerName=mule-$version-$(cat /dev/urandom | env LC_CTYPE=C tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    # GNU/Linux platform detected
    containerName=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-8} | head -n 1)
fi
```

###### Docker run
I've run container in a interactive mode in this scenario [*docker run -i -t*] so that I can shut it down and have the script in the image clean up after Mule is terminated. Note that Mule here is executed in foreground mode. I recommend checking out the startMule.sh script to see what happens inside the container when it runs, and after Mule is terminated.

```sh
docker run -i -t --rm \
  --name $containerName \
  -p $httpPort:8081 \
  -p $httpsPort:8091 \
	knyc/mule-ee:$version \
	$username $password $orgName $envName $containerName-$httpPort-$httpsPort
```

##### Key points to note on the startMule.sh script

The script is based on the version of ARM and CoreServices as of Sept 2016.

> ARM baseUri: https://anypoint.mulesoft.com/hybrid/api/v1

> Core Services baseUri: https://anypoint.mulesoft.com/accounts

On the de-registration of the Mule runtime from Anypoint Runtime Manager, it first checks if the server is a member of a cluster, and if it is, it will proceed to remove itself from the cluster first. The script also further checks if it is the last member of the cluster, and if so, it will proceed to delete the cluster.

[*Again, credits to Nial for the initial work on this script. Slightly modified for my iteration here.*]

## Building your own version

It's easy to do so. The Dockerfile assumes that the required files are all located in the same directory as the Dockerfile. This repo only has the Dockerfile and the scripts. Download/copy the files below as required.

**Current Version: 3.8.1**

The docker container includes
- data-mapper-plugin-3.8.1.zip
- mule-ee-distribution-standalone-3.8.1.tar.gz
- mule-ee-license.lic *(License file installation is commented out on the Dockerfile by default)*

> I've inserted the license installation here so that the image is pre-installed with the license, rather than doing it as part of the Docker run process that requires whoever running it to have the license file. I know this is probably not the best use-case for a generic/public image, but in an enterprise scenario, I assume the license file would also not be freely distributed to everyone that wants to run the image.

To build the docker image use the docker build command with the -t parameter to tag the docker image.
```sh
sudo docker build -t [your-docker-hub-id]/mule-ee:3.8.1 .
```

You can then push it to your own Docker Hub repository.
```sh
sudo docker push [your-docker-hub-id]/mule-ee:3.8.1
```

Check out the Dockerfile of course. I've commented it with notes and it should be self explanatory.
