## How to use with existing mongodb with DATABASE_URI
```sh
$ docker run -d \
             -e DATABASE_URI=${DATABASE_URI:-mongodb://mongodb.intra:27017/dev} \
             -e APP_ID=${APP_ID}                            \
             -e MASTER_KEY=${MASTER_KEY}                    \
             -p 1337:1337                                        \
             --name parse-server                                 \
             yongjhih/parse-server
```

or with docker-compose:

```sh
$ wget https://github.com/yongjhih/docker-parse-server/raw/master/docker-compose.yml
$ DATABASE_URI={mongodb://mongodb.intra:27017/dev} APP_ID={appId} MASTER_KEY={masterKey} docker-compose up
```

## How to use with existing parse-cloud-code
### With host folder:
```sh
$ docker run -d \
             -v ${PARSE_CLOUD:-/home/yongjhih/parse/cloud}:/parse/cloud \
             -e DATABASE_URI=${PARSE_DATABASE_URI:-mongodb://mongodb.intra:27017/dev} \
             -e APP_ID={appId}         \
             -e MASTER_KEY={masterKey} \
             -p 1337:1337              \
             --link mongo              \
             --name parse-server       \
             yongjhih/parse-server
```
### With volume container:
```sh
$ docker create --name parse-cloud-code \
                -v /parse/cloud         \
                ${DOCKER_PARSE_CLOUD:-yongjhih/parse-cloud-code} echo ls /parse/cloud

$ docker run -d \
             --volumes-from parse-cloud-code \
             -e DATABASE_URI=${DATABASE_URI:-mongodb://mongodb.intra:27017/dev} \
             -e APP_ID=${APP_ID}        \
             -e MASTER_KEY=${MASTER_KEY} \
             -p 1337:1337                     \
             --link mongo                     \
             --name parse-server              \
             yongjhih/parse-server
```
## How to specify parse-server version
Specify parse-server:2.2.10:
```sh
$ docker run -d                                \
             -e APP_ID=${APP_ID}         \
             -e MASTER_KEY=${MASTER_KEY} \
             -p 1337:1337                      \
             --link mongo                      \
             --name parse-server               \
             yongjhih/parse-server:2.2.10
```

> ref. https://github.com/ParsePlatform/parse-server/releases
> ref. https://www.npmjs.com/package/parse-server

## How to specify latest commit of [ParsePlatform/parse-server](https://github.com/ParsePlatform/parse-server) of image
```sh
$ docker run -d                                \
             -e APP_ID=${APP_ID}         \
             -e MASTER_KEY=${MASTER_KEY} \
             -p 1337:1337                      \
             --link mongo                      \
             --name parse-server               \
             yongjhih/parse-server:dev
```
## How to start parse dashboard as standalone
Start up parse-dashboard: https://github.com/yongjhih/docker-parse-dashboard  
And, start up other containers without parse-dashboard:

```sh
$ APP_ID=YOUR_APP_ID MASTER_KEY=YOUR_MASTER_KEY docker-compose -f docker-compose-without-dashboard.yml up -d
```
## How to setup SSL with letsencrypt
```sh
$ git clone https://github.com/yongjhih/docker-parse-server
$ cd docker-parse-server

$ USER1=yongjhih \
  USER1_PASSWORD=yongjhih \
  PARSE_DASHBOARD_VIRTUAL_HOST=parse.example.com \
  PARSE_DASHBOARD_LETSENCRYPT_HOST=parse.example.com \
  PARSE_DASHBOARD_LETSENCRYPT_EMAIL=yongjhih@example.com \
  PARSE_SERVER_VIRTUAL_HOST=api.example.com \
  PARSE_SERVER_LETSENCRYPT_HOST=api.example.com \
  PARSE_SERVER_LETSENCRYPT_EMAIL=yongjhih@example.com \
  SERVER_URL=https://api.example.com/parse \
  APP_ID=YOUR_APP_ID MASTER_KEY=YOUR_MASTER_KEY docker-compose -f docker-compose-le.yml up
```

Open your https://parse.example.com/ url and unblock browser protected scripts, that's it.  
BTW, you can remove unused 80 port after volumes/proxy/certs generated:

```sh
sed -i -- '/- "80:80"/d' docker-compose-le.yml
```

## How to setup push notification
```
$ mkdir volumes/certs
$ cp /path/your/Certificated.p12 volumes/certs/dev-pfx.p12
$ cp /path/your/cert.pem volumes/certs/dev-pfx-cert.pem
$ cp /path/your/key.pem volumes/certs/dev-pfx-key.pem
$ docker-compose up
```

## How to setup multi IOS p12
```
- APNS_BUNDLES_ID=bundleId1,bundleId2
- APNS_BUNDLES_P12=/certs/cert1.p12,/certs/cert2.p12
- APNS_BUNDLES_PROD=isProd1,idProd2
```

Example :
```
- APNS_BUNDLES_ID=com.mydomain.app1,com.mydomain.app2
- APNS_BUNDLES_P12=/certs/cert-app1.p12,/certs/cert-app2.p12
- APNS_BUNDLES_PROD=false,false
   
```

## How to integrate parse-cloud-code image on GitHub and DockerHub
1. Fork https://github.com/yongjhih/parse-cloud-code
2. Add your cloud code into https://github.com/{username}/parse-cloud-code/tree/master/cloud
3. Create an automated build image on DockerHub for forked {username}/parse-cloud-code repository
4. `docker pull {username}/parse-cloud-code`

Without docker-compose:

* Re/create parse-cloud-code volume container: `docker create -v /parse/code --name parse-cloud-code {username}/parse-cloud-code /bin/true`
* Re/create parse-server container with volume: `docker run -d --volumes-from parse-cloud-code APP_ID={appId} -e MASTER_KEY={masterKey} -p 1337:1337 --link mongo yongjhih/parse-server`

With docker-compose.yml:

```yml
# ...
parse-cloud-code:
  # ...
  image: {username}/parse-cloud-code # Specify your parse-cloud-code image
# ...
```

```sh
docker-compose up
```
## How to config Docker

* Specify application ID: `-e APP_ID={appId}`
* Specify master key: `-e MASTER_KEY={masterKey}`
* Specify database uri: `-e DATABASE_URI={mongodb://mongodb.intra:27017/dev}`
* Specify parse-server port on host: `-p {1338}:1337`
* Specify parse-cloud-code git port on host: `-p {2023}:22`
* Specify database port on host: `-p {27018}:27017`
* Specify parse cloud code host folder: `-v {/home/yongjhih/parse/cloud}:/parse/cloud`
* Specify parse cloud code volume container: `--volumes-from {parse-cloud-code}`
* Specify parse-server prefix: `-e PARSE_MOUNT={/parse}`

## How to config Docker Compose

Environment:

```yml
# ...
parse-server:
  # ...
  environment:
    DATABASE_URI: $DATABASE_URI
    APP_ID: $APP_ID
    MASTER_KEY: $MASTER_KEY
    PARSE_MOUNT: $PARSE_MOUNT # /parse
    COLLECTION_PREFIX: $COLLECTION_PREFIX
    CLIENT_KEY: $CLIENT_KEY
    REST_API_KEY: $REST_API_KEY
    DOTNET_KEY: $DOTNET_KEY
    JAVASCRIPT_KEY: $JAVASCRIPT_KEY
    DOTNET_KEY: $DOTNET_KEY
    FILE_KEY: $FILE_KEY
    FACEBOOK_APP_IDS: $FACEBOOK_APP_IDS
    SERVER_URL: $SERVER_URL
    MAX_UPLOAD_SIZE: $MAX_UPLOAD_SIZE # 20mb
    GCM_ID: $GCM_ID
    GCM_KEY: $GCM_KEY
    PRODUCTION_PFX: $PRODUCTION_PFX
    PRODUCTION_BUNDLE_ID: $PRODUCTION_BUNDLE_ID
    PRODUCTION_CERT: $PRODUCTION_CERT # prodCert.pem
    PRODUCTION_KEY: $PRODUCTION_KEY # prodKey.pem
    DEV_PFX: $DEV_PFX
    DEV_BUNDLE_ID: $DEV_BUNDLE_ID
    DEV_CERT: $DEV_CERT # devCert.pem
    DEV_KEY: $DEV_KEY # devKey.pem
    VERIFY_USER_EMAILS: $VERIFY_USER_EMAILS # false
    ENABLE_ANON_USERS: $ENABLE_ANON_USERS # true
    ALLOW_CLIENT_CLASS_CREATION: $ALLOW_CLIENT_CLASS_CREATION # true
    APP_NAME: $APP_NAME
    PUBLIC_SERVER_URL: $PUBLIC_SERVER_URL
    TRUST_PROXY: $TRUST_PROXY # false
# ...
```

Remote parse-cloud-code image:

```yml
# ...
parse-cloud-code:
  # ...
  image: yongjhih/parse-cloud-code # Specify your parse-cloud-code image
# ...
```

or host folder:

```yml
# ...
parse-cloud-code:
  # ...
  image: yongjhih/parse-server
  volumes:
    - /home/yongjhih/parse/cloud:/parse/cloud
  # ...
# ...
```

## How to import ssh-key from github
```sh
$ curl https://github.com/yongjhih.keys | docker exec -i parse-server ssh-add-key
```

# Getting Started With Cloud Services
## Getting Started With Heroku + Mongolab Development
### With the Heroku Button

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

### Without It

* Clone the repo and change directory to it
* Log in with the [Heroku Toolbelt](https://toolbelt.heroku.com/) and create an app: `heroku create`
* Use the [MongoLab addon](https://elements.heroku.com/addons/mongolab): `heroku addons:create mongolab:sandbox`
* By default it will use a path of /parse for the API routes.  To change this, or use older client SDKs, run `heroku config:set PARSE_MOUNT=/1`
* Deploy it with: `git push heroku master`

## Getting Started With AWS Elastic Beanstalk

### With the Deploy to AWS Button

<a title="Deploy to AWS" href="https://console.aws.amazon.com/elasticbeanstalk/home?region=us-west-2#/newApplication?applicationName=ParseServer&solutionStackName=Node.js&tierName=WebServer&sourceBundleUrl=https://s3.amazonaws.com/elasticbeanstalk-samples-us-east-1/eb-parse-server-sample/parse-server-example.zip" target="_blank"><img src="http://d0.awsstatic.com/product-marketing/Elastic%20Beanstalk/deploy-to-aws.png" height="40"></a>

### Without It

* Clone the repo and change directory to it
* Log in with the [AWS Elastic Beanstalk CLI](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install.html), select a region, and create an app: `eb init`
* Create an environment and pass in MongoDB URI, App ID, and Master Key: `eb create --envvars DATABASE_URI=<replace with URI>,APP_ID=<replace with Parse app ID>,MASTER_KEY=<replace with Parse master key>`

## Getting Started With Microsoft Azure App Service
### With the Deploy to Azure Button

[![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://azuredeploy.net/)

### Without It

A detailed tutorial is available here:
[Azure welcomes Parse developers](https://azure.microsoft.com/en-us/blog/azure-welcomes-parse-developers/)

## Getting Started With Google App Engine

1. Clone the repo and change directory to it
1. Create a project in the [Google Cloud Platform Console](https://console.cloud.google.com/).
1. [Enable billing](https://console.cloud.google.com/project/_/settings) for your project.
1. Install the [Google Cloud SDK](https://cloud.google.com/sdk/).
1. Setup a MongoDB server.  You have a few options:
  1. Create a Google Compute Engine virtual machine with [MongoDB pre-installed](https://cloud.google.com/launcher/?q=mongodb).
  1. Use [MongoLab](https://mongolab.com/google/) to create a free MongoDB deployment on Google Cloud Platform.
1. Modify `app.yaml` to update your environment variables.
1. Delete `Dockerfile`
1. Deploy it with `gcloud preview app deploy`

A detailed tutorial is available here:
[Running Parse server on Google App Engine](https://cloud.google.com/nodejs/resources/frameworks/parse-server)

## Getting Started With Scalingo

### With the Scalingo button

[![Deploy to Scalingo](https://cdn.scalingo.com/deploy/button.svg)](https://my.scalingo.com/deploy)

### Without it

* Clone the repo and change directory to it
* Log in with the [Scalingo CLI](http://cli.scalingo.com/) and create an app: `scalingo create my-parse`
* Use the [Scalingo MongoDB addon](https://scalingo.com/addons/scalingo-mongodb): `scalingo addons-add scalingo-mongodb free`
* Setup MongoDB connection string: `scalingo env-set DATABASE_URI='$SCALINGO_MONGO_URL'`
* By default it will use a path of /parse for the API routes. To change this, or use older client SDKs, run `scalingo env-set PARSE_MOUNT=/1`
* Deploy it with: `git push scalingo master`

> You can change the server URL in all of the open-source SDKs, but we're releasing new builds which provide initialization time configuration of this property.
