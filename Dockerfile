FROM ruby:2.7

WORKDIR /app

RUN apt-get update && \
    apt-get install unzip -y

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf aws/

COPY Gemfile* /app/

RUN bundle install --system && \
    rm -rf ~/.gem /root/.bundle/cache /usr/local/bundle/cache

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG JENKINS_HOME=/var/jenkins_home

ENV JENKINS_HOME $JENKINS_HOME

RUN mkdir -p $JENKINS_HOME \
  && chown ${uid}:${gid} $JENKINS_HOME \
  && addgroup -g ${gid} ${group} \
  && adduser -h "$JENKINS_HOME" -u ${uid} -G ${group} -s /bin/bash -D ${user}

VOLUME $JENKINS_HOME

RUN chown -R ${user} "$JENKINS_HOME"

USER ${user}

# COPY . /app

