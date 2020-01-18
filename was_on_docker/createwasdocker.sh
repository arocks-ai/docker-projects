#!/bin/bash

#### Script to create docker image based on IBM WAS server
echo === Script to create docker image based on IBM WAS server ...
echo == Make sure that IBMID, IBMID_PWD, IMURL variables are updated before running this script


# Get IBM Build Image from the following link
# https://github.com/WASdev/ci.docker.websphere-traditional/blob/master/docker-build/download-iim.md

# local variables
WAS_DOCKER_IMAGE_NAME=websphere-traditional:8.5
WAS_DOCKER_CONTAINER_NAME=wasv85server



## Build WAS server Docker Image 
echo == Creating WAS docker image ..
echo = IBMid = $IBMid
echo = IBMid_password = $IBMid_password
echo = IBM_Installation_Manager_download_url = $IBM_Installation_Manager_download_url
echo = WAS_DOCKER_IMAGE_NAME = $WAS_DOCKER_IMAGE_NAME
echo = WAS_DOCKER_CONTAINER_NAME = $WAS_DOCKER_CONTAINER_NAME

read -p "check variables"

sudo docker build -t $WAS_DOCKER_IMAGE_NAME . -f ./Dockerfile_local \
    --build-arg IBMID=$IBMid \
    --build-arg IBMID_PWD=$IBMid_password \
    --build-arg IMURL=$IBM_Installation_Manager_download_url \
    --build-arg IFIXES=recommended

[ $? -eq 0 ] || exit 1


## Delete existing docker containier
echo == deleting any existing WAS containers ..
if [[ $(sudo docker ps -a | grep -c $WAS_DOCKER_CONTAINER_NAME) > 0 ]]
then 
  sudo docker rm -f $WAS_DOCKER_CONTAINER_NAME 
fi

## Create container based on the  ImageName
echo == Creating container based Image, $ImageName
sudo docker run -d -t --name $WAS_DOCKER_CONTAINER_NAME -p 9043:9043 -p 9443:9443 -p 9060:9060 -p 9080:9080 $WAS_DOCKER_IMAGE_NAME

#[ $? -eq 0 ]  || (echo "=== ERROR. Continer creation failed .." || exit 1)
[ $? -eq 0 ] || exit 1

## Check container 
echo == Checking container ..
if [[ $(sudo docker ps | grep -c $WAS_DOCKER_CONTAINER_NAME) > 0 ]]
then 
  echo == Container $WAS_DOCKER_CONTAINER_NAME created and running ..
else
  echo == ERROR. Container $WAS_DOCKER_CONTAINER_NAME is not running ..
fi

## Get container ID
# sudo docker ps --filter name=$WAS_DOCKER_CONTAINER_NAME -aq	# Get docker ID
wasv85dockerid=$(sudo docker ps --filter name=$WAS_DOCKER_CONTAINER_NAME -aq)  # check if export needed
#export wasv85dockerid
echo = container ID = $wasv85dockerid


## Get logs
sudo docker logs $wasv85dockerid		# To get logs of container


## Create and start running WAS Profile by running script /work/create_and_start.sh
echo == Create and start running WAS Profile ...
# sudo docker exec -t $wasv85dockerid /work/start_server.sh
# sudo docker exec -t $wasv85dockerid /work/create_and_start.sh
sudo docker exec -t $wasv85dockerid /bin/bash
#[ $? -eq 0 ]  || (echo "=== ERROR. docker exec $wasv85dockerid failed .." || exit 1)
[ $? -eq 0 ] || exit 1

## wsadmin login 
## https://localhost:9043/ibm/console/login.do
# First Get wsadmin password (dynamically generated)
sudo docker exec -t $wasv85dockerid cat /tmp/PASSWORD
echo == Admin console user =  wsadmin, password = 


## STOP server
#PROFILE_NAME=AppSrv01
#SERVER_NAME=server1
#sudo docker exec -t 97b19ea55391 /opt/IBM/WebSphere/AppServer/profiles/$PROFILE_NAME/bin/stopServer.sh $SERVER_NAME

