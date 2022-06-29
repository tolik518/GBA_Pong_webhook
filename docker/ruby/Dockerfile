FROM ruby:3.0-alpine

RUN apk add build-base
RUN gem install sinatra 
RUN gem install thin 
RUN gem install httparty
RUN gem install dotenv

CMD ruby

EXPOSE 4567