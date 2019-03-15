FROM ruby:2.6.0

RUN apt-get update -qq
RUN apt-get install -y --no-install-recommends
RUN apt-get install -y build-essential
RUN apt-get install -y nodejs 

RUN apt-get install default-libmysqlclient-dev mysql-client -y
RUN apt-get update

RUN mkdir /mnt/rails
WORKDIR /mnt/rails

COPY Gemfile /mnt/rails/
COPY Gemfile.lock /mnt/rails/

# Bundle install
RUN bundle install
COPY . /mnt/rails

EXPOSE 3000
