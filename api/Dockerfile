FROM ruby:3.1.2-bullseye
WORKDIR /app
COPY Gemfile /app
COPY Gemfile.lock /app
COPY . /app
ENV TZ Asia/Tokyo

RUN apt-get update -qq && apt-get install -y build-essential nodejs libpq-dev
RUN gem update bundler && bundle install

ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
