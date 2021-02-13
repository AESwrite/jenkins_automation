#!/bin/bash

# Configurable script to build jenkins image and run it as a container

echo ">> EXPORT jenkins variables from jenkins_globals.bash"
source .env

# Function to get jenkins uid and docker guid and set them as variables
function collect_uid_guid {
  JENKINS_HOST_UID=$(id -u jenkins)
  DOCKER_HOST_GID=$(getent group | grep docker | cut -d ':' -f 3)
  echo ">> SET JENKINS_HOST_UID to ${JENKINS_HOST_UID}"
  echo ">> SET DOCKER_HOST_GID to ${DOCKER_HOST_GID}"
}

echo ">>  Check if user jenkins exists."
if id -u "jenkins" >/dev/null 2>&1; then
  echo ">> User jenkins already exists."
  collect_uid_guid
else
  echo ">> User jenkins does not exist, creating it, PLEASE enter password."
  sudo useradd jenkins
  collect_uid_guid
fi

echo ">> Check if ${HOST_JENKINS_VOLUME} exists."
[ ! -d $HOST_JENKINS_VOLUME ] && \
echo ">> Creating , PLEASE enter your password." && \
sudo mkdir -p $HOST_JENKINS_VOLUME

echo ">> Adding jenkins user to docker group. PlEASE enter password if asked."
sudo usermod -aG docker jenkins

read -p ">> WARNING: Going to restart docker.service. Y - to continue, N - to abort. -  " -n 1 -r
case "$REPLY" in 
  y|Y ) sudo service docker restart;;
  n|N ) echo "Stop execution" && exit 1;;
  * ) echo "invalid answer, try Y/y or N/n";;
esac

echo ">> Building ${CONATAINER_NAME}..."
docker-compose build \
--build-arg HOST_UID=$JENKINS_HOST_UID \
--build-arg HOST_GID=$DOCKER_HOST_GID \
--build-arg COMPOSE_VERSION=$DOCKER_COMPOSE_VERSION

# echo ">> Copying jenkins configuration."
# sudo cp casc.yaml ${HOST_JENKINS_VOLUME}

echo ">> Set ownership of the ${HOST_JENKINS_VOLUME} for jenkins user"
sudo chgrp -R jenkins $HOST_JENKINS_VOLUME 
sudo chown -R jenkins $HOST_JENKINS_VOLUME

echo ">> Starting ${CONATAINER_NAME}"
docker-compose up -d
echo ">>>>>>>>>>>>>> FINISHED"
docker ps | grep "${CONATAINER_NAME}"