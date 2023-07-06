#
#
#   ATLYS CHANNEL SYSTEM
#      Docker Image
#
#   docker build -t atlyschannel:latest .
#
#

FROM ruby:2.2.3

EXPOSE 11211
EXPOSE 3000

RUN apt-get update -qq && apt-get install -y build-essential apt-utils libpq-dev wget \
	libxml2-dev libxslt1-dev curl \
	mysql-client libmysqlclient-dev \
	imagemagick screen cron

RUN gem install rails -v 4.2.5 --no-rdoc --no-ri; gem install bundler

ENV APP_HOME /
WORKDIR $APP_HOME
RUN mkdir application
WORKDIR $APP_HOME/application
RUN mkdir -p public/uploads; chmod -R 777 public; mkdir -p tmp/delayed_job

RUN gem update --system
RUN gem update
RUN gem install sass
RUN gem install carrierwave
RUN gem install carrierwave-base64
RUN gem install multi_json
RUN gem install json
RUN gem install eventmachine
RUN gem install mysql2
RUN gem install god
RUN gem install turbolinks
RUN gem install authorizenet
RUN gem update


COPY ./Gemfile Gemfile
COPY ./Gemfile.lock Gemfile.lock

RUN bundle install
RUN gem update --system
RUN gem update

COPY ./ /application

CMD ["/bin/bash"]
ENV RAILS_ENV production

# Logging
RUN mkdir log; touch log/$RAILS_ENV.log; ln -sf /dev/stdout log/$RAILS_ENV.log
RUN chmod 777 upstart.sh

ENTRYPOINT ["/bin/bash", "-c", "./upstart.sh"]
