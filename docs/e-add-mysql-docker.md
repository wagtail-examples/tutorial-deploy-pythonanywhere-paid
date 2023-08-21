# Add a local mysql docker container for development

As I mentioned, the database will be switched from using sqlite3 to mysql. Here a new docker-compose setup will be added that can be used to spin up the database locally for development.

Create a `docker-compose.yml` file in the root of the project and add the following content:

```yaml
services:
  db:
    image: mysql:5.7 # version in use on pythonanywhere
    command: --default-authentication-plugin=mysql_native_password
    env_file:
      - .env
    ports:
      - "3306:3306"
    volumes:
      - dbdata:/var/lib/mysql
    container_name: mysql
    healthcheck:
      test: [ "CMD", "mysqladmin", "ping", "-h", "localhost" ]
      interval: 10s
      timeout: 20s
      retries: 5

  adminer:
    image: adminer
    ports:
      - 8080:8080
    depends_on:
      db:
        condition: service_healthy

volumes:
  dbdata:
```

You will need docker installed to run the compose file: try [Orbstack](https://orbstack.dev)

From the root of your project run:

```bash
docker-compose up -d
```

> Becuase the .env file is available the running db container will use the MYSQL_... env vars. Therefore the username, password and database name are initialized to `webapp`
>
> To check the database is running, open a web browser and go to http://localhost:8080 and login with `webapp` as the username and password. You should see the database named `webapp` has been created.
>
> If you already have a mysql server running locally you can probably skip this step.

Up Next - [Configure Wagtail to use the Mysql database](./f-switch-to-mysql.md)
