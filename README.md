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

### Usage of already mongodb with DATABASE_URI

```sh
docker run -d -e DATABASE_URI={mongodb://mongodb.intra:27017/dev} APP_ID={appId} -e MASTER_KEY={masterKey} -e FILE_KEY={fileKey} -p 1337:1337 --link mongo yongjhih/parse-server
```

or with docker-compose:

```sh
wget https://github.com/yongjhih/docker-parse-server/blob/master/docker-compose.yml
DATABASE_URI={mongodb://mongodb.intra:27017/dev} APP_ID=myAppId MASTER_KEY=myMasterKey docker-compose up
```

## Configuration

* APP_ID
* MASTER_KEY
* FILE_KEY
* Specify database uri: `-e DATABASE_URI=mongodb://mongodb.intra:27017/dev`
* Specify parse-server port on host: `-p 1338:1337`
* Specify database port on host: `-p 27018:27017`
* Specify parse code folder: `-v /home/yongjhih/parse/cloud:/parse/cloud`
* Specify parse-server prefix: `-e PARSE_ROOT=/parse`

## See Also

* https://github.com/ParsePlatform/parse-server
* http://blog.parse.com/announcements/introducing-parse-server-and-the-database-migration-tool/
* https://parse.com/docs/server/guide#migrating
* https://hub.docker.com/r/yongjhih/parse-server/
* https://medium.com/cowbear-coder/migration-of-parse-server-with-docker-part1-87034cc29978
