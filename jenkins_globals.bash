#!/bin/bash

# Customize jenkins container here

IMAGE_NAME="jenkins"
IMAGE_TAG="jcasc"

CONATAINER_NAME="jenkins-jcasc"

HOST_PORT="8080"
CONTAINER_PORT="8080"

RM_FLAG="--rm" # set to ''/'--rm' to disable/enable
RESTART_FLAG="" # set to ''/"--restart='always'" to disable/enable
MEMORY="--memory=1024m" # change only decimal value
MEMORY_SWAP="--memory-swap=1g" # change only decimal value

# Jenkins IP config
SERVER_IP='127.0.0.1'

# Credentials config
ADMIN_NAME="admin"
ADMIN_PASSWORD="admin"