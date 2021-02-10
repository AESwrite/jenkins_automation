#!/bin/bash

# Configurable script to build jenkins image and run it as a container

source jenkins_globals.bash

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
