#!/usr/bin/env node
// ref. parse-server/index.js
// ref. parse-server/bin/parse-server

var express = require('express');
var ParseServer = require('parse-server').ParseServer;
var links = require('docker-links').parseLinks(process.env);
var fs = require('fs');

var databaseUri = process.env.DATABASE_URI || process.env.MONGODB_URI

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

var iosPushConfigs = new Array();
var isFile = function(f) {
    var b = false;
    try {
        b = fs.statSync(f).isFile();
    } catch (e) {
    }
    return b;
}

var productionBundleId = process.env.PRODUCTION_BUNDLE_ID;
var productionPfx = process.env.PRODUCTION_PFX || '/certs/production-pfx.p12';
productionPfx = isFile(productionPfx) ? productionPfx : null;
var productionCert = process.env.PRODUCTION_CERT || '/certs/production-pfx-cert.pem';
productionCert = isFile(productionCert) ? productionCert : null;
var productionKey = process.env.PRODUCTION_KEY || '/certs/production-pfx-key.pem';
productionKey = isFile(productionKey) ? productionKey : null;
var productionPushConfig;
if (productionBundleId && (productionPfx || (productionCert && productionKey))) {
    productionPushConfig = {
        pfx: productionPfx,
        cert: productionCert,
        key: productionKey,
        bundleId: productionBundleId,
        production: true
    };
    iosPushConfigs.push(productionPushConfig);
}

var devBundleId = process.env.DEV_BUNDLE_ID;
var devPfx = process.env.DEV_PFX || '/certs/dev-pfx.p12';
devPfx = isFile(devPfx) ? devPfx : null;
var devCert = process.env.DEV_CERT || '/certs/dev-pfx-cert.pem';
devCert = isFile(devCert) ? devCert : null;
var devKey = process.env.DEV_KEY || '/certs/dev-pfx-key.pem';
devKey = isFile(devKey) ? devKey : null;
var devPushConfig;
if (devBundleId && (devPfx || (devCert && devKey))) { // exsiting files if not null
    devPushConfig = {
        pfx: devPfx,
        cert: devCert,
        key: devKey,
        bundleId: devBundleId,
        production: false
    };
    iosPushConfigs.push(devPushConfig);
}

if(process.env.APNS_BUNDLES_ID && process.env.APNS_BUNDLES_P12 && process.env.APNS_BUNDLES_PROD) {
    var APNSBundlesId = process.env.APNS_BUNDLES_ID.split(',').map(function(entry) {
        return entry.trim();
    });
    var APNSBundlesP12 = process.env.APNS_BUNDLES_P12.split(',').map(function(entry) {
        return entry.trim();
    });
    var APNSBundlesProd = process.env.APNS_BUNDLES_PROD.split(',').map(function(entry) {
        return entry.trim();
    });
    if(APNSBundlesId.length === APNSBundlesP12.length && APNSBundlesP12.length === APNSBundlesProd.length) {
        for (var i = 0; i < APNSBundlesId.length; i++) {
            APNSpushConfig = {
                pfx: APNSBundlesP12[i],
                bundleId: APNSBundlesId[i],
                production: (APNSBundlesProd[i] === 'true' ? true : false)
            };
            iosPushConfigs.push(APNSpushConfig);
        }
    }
}



var pushConfig = {};
if (gcmId && gcmKey) {
    pushConfig.android = {
        senderId: gcmId,
        apiKey: gcmKey
    }
}
if (iosPushConfigs.length > 0) {
    pushConfig.ios = iosPushConfigs;
    //console.log('Multiple iOS push configurations.')
}
console.log(pushConfig);

var port = process.env.PORT || 1337;
// Serve the Parse API on the /parse URL prefix
var mountPath = process.env.PARSE_MOUNT || '/parse';
var serverURL = process.env.SERVER_URL || 'http://localhost:' + port + mountPath; // Don't forget to change to https if needed

var S3Adapter = require('parse-server').S3Adapter;
var GCSAdapter = require('parse-server').GCSAdapter;
//var FileSystemAdapter = require('parse-server').FileSystemAdapter;
var filesAdapter;

if (process.env.S3_ACCESS_KEY &&
    process.env.S3_SECRET_KEY &&
    process.env.S3_BUCKET) {
    var directAccess = !!+(process.env.S3_DIRECT);

    filesAdapter = new S3Adapter(
        process.env.S3_ACCESS_KEY,
        process.env.S3_SECRET_KEY,
        process.env.S3_BUCKET,
        {directAccess: directAccess});
} else if (process.env.GCP_PROJECT_ID &&
    process.env.GCP_KEYFILE_PATH &&
    process.env.GCS_BUCKET) {
    var directAccess = !!+(process.env.GCS_DIRECT);

    filesAdapter = new GCSAdapter(
        process.env.GCP_PROJECT_ID,
        process.env.GCP_KEYFILE_PATH,
        process.env.GCS_BUCKET,
        {directAccess: directAccess});
}

var emailModule = process.env.EMAIL_MODULE;
var verifyUserEmails = !!+(process.env.VERIFY_USER_EMAILS);
var emailAdapter;
if (!emailModule) {
    verifyUserEmails = false;
} else {
    emailAdapter = {
        module: emailModule,
        options: {
            fromAddress: process.env.EMAIL_FROM,
            domain: process.env.EMAIL_DOMAIN,
            apiKey: process.env.EMAIL_API_KEY
        }
    };
}
console.log(verifyUserEmails);
console.log(emailModule);
console.log(emailAdapter);

var enableAnonymousUsers = !!+(process.env.ENABLE_ANON_USERS);
var allowClientClassCreation = !!+(process.env.ALLOW_CLIENT_CLASS_CREATION);

var liveQuery = process.env.LIVEQUERY_SUPPORT;
console.log("LIVEQUERY_SUPPORT: " + liveQuery);
var liveQueryParam;
if(liveQuery) {
    var liveQueryClasses = process.env.LIVEQUERY_CLASSES.split(',').map(function(entry) {
        return entry.trim();
    });
    console.log("LIVEQUERY_CLASSES: " + liveQueryClasses);

    liveQueryParam = {
        classNames: liveQueryClasses
    };
}



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
    filesAdapter: filesAdapter,

    facebookAppIds: facebookAppIds,
    maxUploadSize: process.env.MAX_UPLOAD_SIZE,
    push: pushConfig,
    verifyUserEmails: verifyUserEmails,
    emailAdapter: emailAdapter,
    enableAnonymousUsers: enableAnonymousUsers,
    allowClientClassCreation: allowClientClassCreation,
    //oauth = {},
    appName: process.env.APP_NAME,
    publicServerURL: process.env.PUBLIC_SERVER_URL,
    liveQuery: liveQueryParam
    //customPages: process.env.CUSTOM_PAGES || // {
    //invalidLink: undefined,
    //verifyEmailSuccess: undefined,
    //choosePassword: undefined,
    //passwordResetSuccess: undefined
    //}
});

//console.log("appId: " + api.appId);
//console.log("masterKey: " + api.masterKey);
//console.log("cloud: " + api.cloud);
//console.log("databaseURI: " + api.databaseURI);
console.log("appId: " + process.env.APP_ID);
console.log("masterKey: " + process.env.MASTER_KEY);

var app = express();

var trustProxy = !!+(process.env.TRUST_PROXY || '1'); // default enable trust
if (trustProxy) {
    console.log("trusting proxy: " + process.env.TRUST_PROXY);
    app.enable('trust proxy');
}

app.use(mountPath, api);

// Parse Server plays nicely with the rest of your web routes
app.get('/', function(req, res) {
    res.status(200).send('I dream of being a web site.');
});

app.listen(port, function() {
    console.log('docker-parse-server running on ' + serverURL + ' (:' + port + mountPath + ')');
});

if(liveQuery) {
    console.log("Starting live query server")
    var parseLiveQueryServer = ParseServer.createLiveQueryServer(app);
}
