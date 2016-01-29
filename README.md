# docker-parse-server

![](art/parse-rip-32dp.png)

Welcome PR.

Here is overview:

![](art/chart.png)

## Usage

```sh
docker run -d -p 27017:27017 --name mongo mongo
docker run -d -e APP_ID={appId} -e MASTER_KEY={masterKey} -e FILE_KEY={fileKey} -p 1337:1337 --link mongo yongjhih/parse-server
```

* api: localhost:1337
* mongodb: localhost:27017

or with docker-compose:

```sh
wget https://github.com/yongjhih/docker-parse-server/blob/master/docker-compose.yml
APP_ID=myAppId MASTER_KEY=myMasterKey docker-compose up
```

## Configuration

* APP_ID
* MASTER_KEY
* FILE_KEY
* DATABASE_URI={mongodb://localhost:27017/dev}

## TODO

* TODO: DATABASE_PORT={27017} (immutex DATABASE_URI)
* TODO: API_PORT={80}
* TODO: CLOUD_URI={https://github.com/yongjhih/simple-parse-cloud}
* TODO: CLOUD_PATH={/home/yongjhih/works/parse-server/cloud/main.js} (immutex CLOUD_URI)

## See Also

* https://github.com/ParsePlatform/parse-server
* http://blog.parse.com/announcements/introducing-parse-server-and-the-database-migration-tool/
* https://parse.com/docs/server/guide#migrating
* https://hub.docker.com/r/yongjhih/parse-server/
* https://medium.com/cowbear-coder/migration-of-parse-server-with-docker-part1-87034cc29978

## License

Apache 2.0 8tory
