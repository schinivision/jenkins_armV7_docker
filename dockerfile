FROM arm32v7/openjdk:8-jre-slim

RUN apt-get update \
  && apt-get install -y bash git curl zip build-essential \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV JENKINS_HOME /var/jenkins_home
ENV JENKINS_SLAVE_AGENT_PORT 50000

ARG jenkins_version=2.77
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

# Jenkins is run with user `jenkins`, uid = 1000
# If you bind mount a volume from the host or a data container,
# ensure you use the same uid
RUN groupadd -g ${gid} ${group} \
    && useradd -d "$JENKINS_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

# Jenkins home directory is a volume, so configuration and build history
# can be persisted and survive image upgrades
VOLUME /var/jenkins_home

#install docker support before installing jenkins
RUN curl -sSL https://get.docker.com | sh && sudo usermod -aG docker jenkins

#download & install jenkins
USER ${user}
WORKDIR /opt/jenkins
ADD http://mirrors.jenkins-ci.org/war/${jenkins_version}/jenkins.war /opt/jenkins.war
RUN chmod 644 /opt/jenkins.war

ENV JENKINS_UC https://updates.jenkins.io

# for main web interface:
EXPOSE 8080

# will be used by attached slave agents:
EXPOSE 50000

ENTRYPOINT ["java", "-jar", "/opt/jenkins.war"]