#!/bin/bash

# Configurable script to build jenkins image and run it as a container

# Customizable variables
IMAGE_NAME="jenkins"
IMAGE_TAG="jcasc"
CONATAINER_NAME="jenkins"
HOST_PORT="8080"
CONTAINER_PORT="8080"
RM_FLAG="--rm" # set to ''/'--rm' to disable/enable
RESTART_FLAG="--restart='always'" # set to ''/"--restart='always'" to disable/enable
MEMORY="--memory='1024m'" # change only decimal value
MEMORY_SWAP="--memory-swap='1g'" # change only decimal value

# Jenkins IP config
SERVER_IP='127.0.0.1'
# Credentials config
ADMIN_NAME="admin"
ADMIN_PASSWORD="admin6142"


# Build image from current dir and deploy container 
docker build -t $IMAGE_NAME:$IMAGE_TAG .

docker run -d --name $CONATAINER_NAME \
$RM_FLAG \
$RESTART_FLAG \
$MEMORY \
$MEMORY_SWAP \
--env JENKINS_ADMIN_ID=$ADMIN_NAME \
--env JENKINS_ADMIN_PASSWORD=$ADMIN_PASSWORD \
--env SERVER_IP=$SERVER_IP \
-p $HOST_PORT:$CONTAINER_PORT $IMAGE_NAME:$IMAGE_TAG

docker run -d --name jenkins --restart='always' \
--memory="1024m" --memory-swap="1g" --memory-swappiness="100" \
-p 8080:8080 -p 50000:50000 \
-v /data/jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
jenkins_with_docker