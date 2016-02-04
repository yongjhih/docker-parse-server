FROM node:latest

ENV PARSE_HOME /parse

#ADD .js ${PARSE_HOME}/
#ADD *.json ${PARSE_HOME}/
ADD index.js ${PARSE_HOME}/index.js
ADD app.json ${PARSE_HOME}/app.json
ADD azuredeploy.json ${PARSE_HOME}/azuredeploy.json
ADD jsconfig.json ${PARSE_HOME}/jsconfig.json
ADD package.json ${PARSE_HOME}/package.json

ENV CLOUD_CODE_HOME ${PARSE_HOME}/cloud
ADD cloud/*.js $CLOUD_CODE_HOME/

WORKDIR $PARSE_HOME
RUN npm install

ENV APP_ID myAppId
ENV MASTER_KEY myMasterKey
ENV DATABASE_URI mongodb://localhost:27017/dev
ENV CLOUD_CODE_MAIN ${CLOUD_CODE_HOME}/main.js
ENV PARSE_ROOT /parse

ENV PORT 1337

EXPOSE $PORT
VOLUME $CLOUD_CODE_HOME

CMD [ "npm", "start" ]
