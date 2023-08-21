# Configure Wagtail to use the Mysql database

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

> env_vars will hold all the environment variables and we can use them to connect to the local mysql database.
>
> In PythonAnywhere those environment variables will be available but that still needs to be setup.

## Add Django < 4.2 as a python dependency

As python anywhere uses Mysql 5.7 and Django v4.2+ requires Mysql v8.0+ the Django version installed needs to be pinned at v4.1

Run the following to add the Django constraint:

```bash
pipenv install "django>=4.1,<4.2"
```

then write the dependencies to requirements.txt

```bash
pipenv requirements > requirements.txt
```

## Run the Wagtail project locally

Run the Wagtail project locally to check that everything is working as expected:

```bash
pipenv run python manage.py migrate
```

```bash
pipenv run python manage.py createsuperuser
```

```bash
pipenv run python manage.py runserver
```

Open a browser and go to <http://localhost:8000> and you should see the default Wagtail home page.

Open a browser and go to <http://localhost:8000/admin/> and login with the superuser credentials you just created.

Up Next - [Create a Mysql database on PythonAnywhere](./g-create-mysql-on-pythonanywhere.md)
