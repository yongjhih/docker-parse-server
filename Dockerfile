FROM node:latest

ENV PARSE_HOME /parse

#ADD . ${PARSE_HOME}
#ADD *.js ${PARSE_HOME}/
#ADD *.json ${PARSE_HOME}/

ADD index.js ${PARSE_HOME}/index.js
ADD package.json ${PARSE_HOME}/package.json

ADD jsconfig.json ${PARSE_HOME}/jsconfig.json

## deployment is unnecessary
#ADD app.json ${PARSE_HOME}/app.json # heroku
#ADD azuredeploy.json ${PARSE_HOME}/azuredeploy.json # azure

ENV CLOUD_CODE_HOME ${PARSE_HOME}/cloud
ADD cloud/*.js $CLOUD_CODE_HOME/

WORKDIR $PARSE_HOME
RUN npm install

## ENV
#ENV APP_ID myAppId
#ENV MASTER_KEY myMasterKey
#ENV DATABASE_URI mongodb://localhost:27017/dev
#ENV CLOUD_CODE_MAIN ${CLOUD_CODE_HOME}/main.js
#ENV PARSE_MOUNT /parse
#ENV COLLECTION_PREFIX
#ENV CLIENT_KEY
#ENV REST_API_KEY
#ENV DOTNET_KEY
#ENV JAVASCRIPT_KEY
#ENV DOTNET_KEY
#ENV FILE_KEY
#ENV FACEBOOK_APP_IDS "xx,xxx"

ENV PORT 1337

EXPOSE $PORT
VOLUME $CLOUD_CODE_HOME
ENV NODE_PATH .

RUN apt-get update && \
    apt-get install -y --no-install-recommends openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV SSH_PORT 5022
EXPOSE $SSH_PORT

ADD ssh-add-key /usr/bin/ssh-add-key

RUN useradd -s /bin/bash git
RUN echo "git ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN mkdir -p /parse-cloud-code && \
    chown -R git:git /parse-cloud-code && \
    chown -R git:git /parse/cloud

ADD docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD [ "npm", "start" ]
