FROM jenkins/jenkins:latest

ARG HOST_UID
ARG HOST_GID
ARG COMPOSE_VERSION

### Disable setup wizard ###
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
### Configuration as a code config ENV ###
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml

### Plugins management ###
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

### Configuration as a code config ###
COPY casc.yaml /var/jenkins_home/casc.yaml

### Docker block, uncomment if you need docker inside jenkins container ###
USER root
RUN apt-get -y update && \
    apt-get -y install apt-transport-https ca-certificates curl gnupg-agent software-properties-common && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get -y install docker-ce docker-ce-cli containerd.io
RUN curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    
RUN usermod -u $HOST_UID jenkins
RUN groupmod -g $HOST_GID docker
RUN usermod -aG docker jenkins

USER jenkins