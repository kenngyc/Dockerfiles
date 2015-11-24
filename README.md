# Dockerfiles

The Dockerfile assumes that the required files are all located in the same directory as the Dockerfile. Note that this is based on the current version of Mule and API Gateway, you can edit the Dockerfile as required. The Dockerfile also installs the Mule Agent v1.2 and the Datamapper plugin. This repo only has the Dockerfiles. Download/copy the files below as required.

For the Mule EE:-
- data-mapper-plugin-3.7.2.zip
- mule-ee-distribution-standalone-3.7.2.tar.gz
- mule-agent-1.2.0.tar.gz
- mule-ee-license.lic *(License file installation is commented out on the Dockerfile by default)*

For the API Gateway:-
- api-gateway-standalone-2.1.0.tar.gz
- data-mapper-plugin-3.7.2.zip
- mule-agent-1.2.0.tar.gz
- apigw-ee-license.lic *(License file installation is commented out on the Dockerfile by default)*

To build the docker image use the docker build command with the -t parameter to tag the docker image.
```sh
sudo docker build -t knyc/mule-trial:3.7.2 .
```

You can then push it to your own Docker Hub repository. 
```sh
sudo docker push knyc/mule-trial:3.7.2
```

The Docker image is configured to run mule and gateway in foreground mode. I've done this as I was running the runtime with Rancher and the foreground mode allowed me to view the logs easily from Rancher. You can easily change this CMD line in the Dockerfile to run it in background mode instead.

To pair the runtime with ARM, just run the AMC setup command by executing a bash terminal on the container where Mule or API Gateway is running. This is of course a lot easier with Rancher.
```sh
sudo docker exec -i -t 665b4a1e17b6 bash
```

After running the AMC setup script, just restart the container and you will be able to see the it running on ARM.
