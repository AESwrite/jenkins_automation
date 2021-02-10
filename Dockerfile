### Default ###
FROM jenkins/jenkins:latest

### Disable setup wizard ###
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
### Configuration as a code config ENV ###
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml

### Plugins management ###
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

### Configuration as a code config ###
COPY casc.yaml /var/jenkins_home/casc.yaml

### Docker block, uncomment if you need access to host docker daemon ###



