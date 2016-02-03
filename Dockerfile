FROM node:latest

ENV PARSE_HOME /parse

RUN mkdir -p $PARSE_HOME

ADD index.js ${PARSE_HOME}/index.js
ADD app.json ${PARSE_HOME}/app.json
ADD azuredeploy.json ${PARSE_HOME}/azuredeploy.json
ADD jsconfig.json ${PARSE_HOME}/jsconfig.json
ADD package.json ${PARSE_HOME}/package.json

ENV CLOUD_CODE_HOME ${PARSE_HOME}/cloud
ADD cloud $CLOUD_CODE_HOME

WORKDIR $PARSE_HOME
RUN npm install

ENV APP_ID setYourAppId
ENV MASTER_KEY setYourMasterKey
ENV DATABASE_URI setMongoDBURI
ENV CLOUD_CODE_MAIN ${CLOUD_CODE_HOME}/main.js
ENV PARSE_ROOT /parse

ENV PORT 1337

EXPOSE $PORT
VOLUME $CLOUD_CODE_HOME

CMD [ "npm", "start" ]
