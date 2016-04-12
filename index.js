#!/usr/bin/env node
// ref. parse-server/index.js
// ref. parse-server/bin/parse-server

var express = require('express');
var ParseServer = require('parse-server').ParseServer;
var links = require('docker-links').parseLinks(process.env);

var databaseUri = process.env.DATABASE_URI || process.env.MONGOLAB_URI;

if (!databaseUri) {
  if (links.mongo) {
    databaseUri = 'mongodb://' + links.mongo.hostname + ':' + links.mongo.port + '/dev';
  }
}

if (!databaseUri) {
  console.log('DATABASE_URI not specified, falling back to localhost.');
}

var facebookAppIds = process.env.FACEBOOK_APP_IDS;

if (facebookAppIds) {
  facebookAppIds = facebookAppIds.split(",");
}

var gcmId = process.env.GCM_ID;
var gcmKey = process.env.GCM_KEY;
var productionPfx = process.env.PRODUCTION_PFX;
var productionBundleId = process.env.PRODUCTION_BUNDLE_ID;
var devPfx = process.env.DEV_PFX;
var devBundleId = process.env.DEV_BUNDLE_ID;
var pushConfig;

if ((gcmId && gcmKey) || (productionPfx && productionBundleId) || (devBundleId && devPfx)) {
  pushConfig = {
    android: {
      senderId: process.env.GCM_ID || '',
      apiKey: process.env.GCM_KEY || ''
    },
    ios: [
      {
        pfx: process.env.DEV_PFX || '',
        bundleId: process.env.DEV_BUNDLE_ID || '',
        production: false
      },
      {
        pfx: process.env.PRODUCTION_PFX || '',
        bundleId: process.env.PRODUCTION_BUNDLE_ID || '',
        production: true
      }
    ]
  };
}

var port = process.env.PORT || 1337;
// Serve the Parse API on the /parse URL prefix
var mountPath = process.env.PARSE_MOUNT || '/parse';
var serverURL = process.env.SERVER_URL || 'http://localhost:' + port + mountPath; // Don't forget to change to https if needed

var api = new ParseServer({
  databaseURI: databaseUri || 'mongodb://localhost:27017/dev',
  cloud: process.env.CLOUD_CODE_MAIN || __dirname + '/cloud/main.js',

  appId: process.env.APP_ID || 'myAppId',
  masterKey: process.env.MASTER_KEY, //Add your master key here. Keep it secret!
  serverURL: serverURL,

  collectionPrefix: process.env.COLLECTION_PREFIX,
  clientKey: process.env.CLIENT_KEY,
  restAPIKey: process.env.REST_API_KEY,
  dotNetKey: process.env.DOTNET_KEY,
  javascriptKey: process.env.JAVASCRIPT_KEY,
  dotNetKey: process.env.DOTNET_KEY,
  fileKey: process.env.FILE_KEY,

  facebookAppIds: facebookAppIds,
  maxUploadSize: process.env.MAX_UPLOAD_SIZE,
  push: pushConfig,
  verifyUserEmails: process.env.VERIFY_USER_EMAILS,
  enableAnonymousUsers: process.env.ENABLE_ANON_USERS,
  allowClientClassCreation: process.env.ALLOW_CLIENT_CLASS_CREATION,
  //oauth = {},
  appName: process.env.APP_NAME,
  publicServerURL: process.env.PUBLIC_SERVER_URL
  //customPages: process.env.CUSTOM_PAGES || // {
    //invalidLink: undefined,
    //verifyEmailSuccess: undefined,
    //choosePassword: undefined,
    //passwordResetSuccess: undefined
  //}
});

var app = express();

if(process.env.TRUST_PROXY == 1) {
  console.log("trusting proxy");
  app.enable('trust proxy');
}

app.use(mountPath, api);

// Parse Server plays nicely with the rest of your web routes
app.get('/', function(req, res) {
  res.status(200).send('I dream of being a web site.');
});

app.listen(port, function() {
  console.log('parse-server-example running on ' + serverURL + ' (:' + port + mountPath + ')');
});
