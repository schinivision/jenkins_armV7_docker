FROM arm32v7/openjdk:8-jdk-slim

RUN apt-get update \
  && apt-get install -y bash git curl zip build-essential \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*