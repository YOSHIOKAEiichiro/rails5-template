FROM ruby:2.4.1-alpine

ENV APP_ROOT /usr/src/calendar
WORKDIR $APP_ROOT

RUN apk update && \
    apk upgrade && \
    apk add --update\
    bash \
    build-base \
    postgresql-dev \
    curl-dev \
    git \
    libxml2-dev \
    libxslt-dev \
    linux-headers \
    mysql-dev \
    nodejs \
    openssh \
    ruby-dev \
    ruby-json \
    tzdata \
    yaml \
    yaml-dev \
    zlib-dev

COPY Gemfile $APP_ROOT
COPY Gemfile.lock $APP_ROOT

RUN bundle config build.nokogiri --use-system-libraries
RUN bundle install

COPY . $APP_ROOT

EXPOSE  3100

CMD ["rails", "server", "-b", "0.0.0.0"]