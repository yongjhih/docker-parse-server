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

#RUN mkdir /var/run/sshd
#RUN echo 'root:screencast' | chpasswd
#RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
#
## SSH login fix. Otherwise user is kicked off after login
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV SSH_PORT 5022
EXPOSE $SSH_PORT

#ENV NOTVISIBLE "in users profile"
#RUN echo "export VISIBLE=now" >> /etc/profile

ADD ssh-add-key /usr/sbin/ssh-add-key

ADD docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

#ENV USER parse
#ENV UID 1000
#
#RUN useradd -d "$PARSE_HOME" -u $UID -m -s /bin/bash $USER
#USER $USER

CMD [ "npm", "start" ]
