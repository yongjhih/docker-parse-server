var express = require('express');
var ParseServer = require('parse-server').ParseServer;

var app = express();

// Specify the connection string for your mongodb database
// and the location to your Parse cloud code
var api = new ParseServer({
    databaseURI: process.env.DATABASE_URI || 'mongodb://localhost:27017/dev',
    cloud: process.env.CLOUD_PATH || '/cloud/main.js', // Provide an absolute path
    appId: process.env.APP_ID || 'myAppId',
    masterKey: process.env.MASTER_KEY || 'mySecretMasterKey',
    fileKey: process.env.FILE_KEY || 'optionalFileKey'
});

// Serve the Parse API on the /parse URL prefix
app.use('/parse', api);

// Hello world
app.get('/', function(req, res) {
    res.status(200).send('Express is running here.');
});

var port = process.env.PORT || 1337;
app.listen(port, function() {
    console.log('parse-server-example running on port ' + port + '.');
});
