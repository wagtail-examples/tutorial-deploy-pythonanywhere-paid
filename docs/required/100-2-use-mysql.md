# Setup to use Mysql

## Setup environment variables

To handle the configuration of the Wagtail app to use mysql and later other settings I'll set up some environment variables.

### Add a file to store the environment variables

```bash
touch .env
```

and add the following content

```txt
MYSQL_ROOT_PASSWORD=webapp
MYSQL_DATABASE=webapp
MYSQL_USER=webapp
MYSQL_PASSWORD=webapp
MYSQL_ROOT_HOST='%'
MYSQL_HOST='127.0.0.1'
MYSQL_PORT=3306
```

Although these variables aren't secret, later on we may add some that are and use it a template to create a `.env` file next.

To make sure the .env file doesn't get committed add the `.env` file to the `.gitignore` file:

```bash
echo ".env" >> .gitignore
```

These are development variables and to save having to set them every time I create a `.env.example` file to use as a template which can be committed to git (make sure there are no real secrets in this file). Then next time I need to set up for development I can just copy the `.env.example` file to `.env` and edit the values there.

```bash
cp .env .env.example
```

## Add a mysql docker container for development

You will need docker installed to run the compose file: try [Orbstack](https://orbstack.dev)

This is a docker-compose setup will be added that can be used to spin up the database locally for development. If you already have Mysql running locally you can probably skip this step and use that instead.

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

Then from the root of your project run:

```bash
docker-compose up -d
```

Because the .env file is available the running db container will use the MYSQL_... env vars. Therefore the username, password and database name are initialized to `webapp`

The adminer service is a web interface to the database. To check the database is running, open a web browser and go to http://localhost:8080 and login with `webapp` as the username and password. You should see the database named `webapp` has been created.

## Configure Wagtail to use the Mysql database

Open `webapp/settings/base.py` and find:

```python
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": os.path.join(BASE_DIR, "db.sqlite3"),
    }
}
```

and replace it with:

```python
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.mysql",
        "NAME": env_vars["MYSQL_DATABASE"] if "MYSQL_DATABASE" in env_vars else "",
        "USER": env_vars["MYSQL_USER"] if "MYSQL_USER" in env_vars else "",
        "PASSWORD": env_vars["MYSQL_PASSWORD"] if "MYSQL_PASSWORD" in env_vars else "",
        "HOST": env_vars["MYSQL_HOST"] if "MYSQL_HOST" in env_vars else "",
        "PORT": env_vars["MYSQL_PORT"] if "MYSQL_PORT" in env_vars else "",
    }
}
```

Somewhere near the top of `base.py` add the following:

```python
### existing code
import os

PROJECT_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
BASE_DIR = os.path.dirname(PROJECT_DIR)
### end existing code

env_vars = os.environ.copy() ### add this line
```

`env_vars` will hold all the environment variables and we can use them to connect to the local mysql database. In PythonAnywhere those environment variables will be available but that still needs to be setup.

### Other Wagtail settings from environment variables

Still in `base.py` find the following lines:

```python
### existing code
env_vars = os.environ.copy()
### end existing code

### add this code block
if "DJANGO_SECRET_KEY" in env_vars:
    SECRET_KEY = env_vars["DJANGO_SECRET_KEY"]

if "DJANGO_ALLOWED_HOSTS" in env_vars:
    ALLOWED_HOSTS = env_vars["DJANGO_ALLOWED_HOSTS"].split(",")
    
### Find WAGTAIL_SITE_NAME = "webapp" and change is to...
WAGTAIL_SITE_NAME = env_vars["WAGTAIL_SITE_NAME"] if "WAGTAIL_SITE_NAME" in env_vars else ""

### WAGTAILADMIN_BASE_URL = "http://example.com" and change it to ...
WAGTAILADMIN_BASE_URL = env_vars["BASE_URL"] if "BASE_URL" in env_vars else ""
```

> When running on production, the environments variables will be loaded from that environment.

Open your local .env file and add these new environment variables and alter the values, also make sure they are available in the .env.example file/

```sh
WAGTAIL_SITE_NAME=site-name
BASE_URL=http://localhost:8000
DJANGO_SECRET_KEY=not-so-secret_key
DJANGO_ALLOWED_HOSTS=localhost
```

In local development they will be picked up by Pipenv and passed to the webapp when it's run. Try out the webapp locally to make sure all is working OK. Most of these settings will be overridden in dev.py when using runserver so probably won't make any difference.

## Run the Wagtail project locally

Run the Wagtail project locally to check that everything is working as expected. **With the virtual environment re-activated** to load the environment variables e.g. `pipenv shell` and run the following commands:

```bash
python manage.py migrate
python manage.py createsuperuser
```

```bash
python manage.py runserver
```

Open a browser and go to <http://localhost:8000> and you should see the default Wagtail home page.

Open a browser and go to <http://localhost:8000/admin/> and login with the superuser credentials you just created.

Up Next - [Set up a webapp and bare-repo on PythonAnywhere](./200-1-webapp-setup.md)
