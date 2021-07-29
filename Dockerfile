FROM ruby:2.7

WORKDIR /app

RUN apt-get update && \
    apt-get install python3 python-pip -y

RUN pip install awscli --upgrade

COPY Gemfile* /app/

RUN bundle install --system && \
    rm -rf ~/.gem /root/.bundle/cache /usr/local/bundle/cache

# COPY . /app

