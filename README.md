# docker-parse-server

## Usage

```sh
docker-compose run -d -e APP_ID={appId} -e MASTER_KEY={masterKey} yongjhih/parse-server
```

* api: localhost:8080
* mongodb: localhost:27017

## Configuration

```sh
docker-compose run -d -e APP_ID={appId} -e MASTER_KEY={masterKey} -e API_PORT=80 -e DB_PORT=27017 yongjhih/parse-server
```

* APP_ID={myAppId}
* MASTER_KEY={mySecretMasterKey}
* FIEL_KEY={optionalFileKey}
* DB_PORT={27017}
* API_PORT={80}
* CLOUD_URL={git@github.com:yongjhih/simple-parse-cloud.git}
* CLOUD={/home/andrew/works/parse-server/cloud/main.js} (immutex CLOUD_URL)
* DB_URL={mongodb://localhost:27017/dev} (immutex DB_PORT)
* PARSE_SERVER_URL={https://github.com/ParsePlatform/parse-server}
* PARSE_SERVER_URL={https://github.com/ParsePlatform/parse-server/tree/2.0.0}
* PARSE_SERVER_URL={https://github.com/ParsePlatform/parse-server/tree/7f5d744}

## See Also

* https://github.com/ParsePlatform/parse-server
* http://blog.parse.com/announcements/introducing-parse-server-and-the-database-migration-tool/
* https://parse.com/docs/server/guide#migrating

## License

Apache 2.0 8tory
