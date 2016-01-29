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

## See Also

* https://github.com/ParsePlatform/parse-server
* http://blog.parse.com/announcements/introducing-parse-server-and-the-database-migration-tool/
* https://parse.com/docs/server/guide#migrating

## License

Apache 2.0 8tory
