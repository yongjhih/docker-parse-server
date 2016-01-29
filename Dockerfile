FROM node

MAINTAINER Andrew Chen <yongjhih@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y wget git curl zip software-properties-common && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ADD package.json /package.json
ADD jsconfig.json /jsconfig.json
RUN npm install

ADD index.js /index.js
ADD cloud /cloud

EXPOSE 1337
