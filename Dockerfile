FROM ruby:2.4.1-alpine

WORKDIR $APP_ROOT

RUN ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    cp /etc/localtime /etc/localtime.org

RUN apt-get update && \
    apt-get install -y nodejs \
                       npm \
                       mysql-client \
                       postgresql-client \
                       sqlite3 \
                       imagemagick \
                       --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

COPY Gemfile $APP_ROOT
COPY Gemfile.lock $APP_ROOT

RUN \
  echo 'gem: --no-document' >> ~/.gemrc && \
  cp ~/.gemrc /etc/gemrc && \
  chmod uog+r /etc/gemrc && \
  bundle config --global build.nokogiri --use-system-libraries && \
  bundle config --global jobs 4 && \
  bundle install && \
  rm -rf ~/.gem

COPY . $APP_ROOT

EXPOSE  3100

CMD ["rails", "server", "-b", "0.0.0.0"]