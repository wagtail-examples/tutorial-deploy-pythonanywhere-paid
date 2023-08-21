# Start a Wagtail site

Add a .gitignore file so we don't commit anything we shouldn't.

A good example of a python .gitignore file is [https://github.com/github/gitignore/blob/main/Python.gitignore](https://github.com/github/gitignore/blob/main/Python.gitignore)

The .gitignore file should also contain the following at this stage.

```.gitignore
/media
```

Now create the initial Wagtail site called `webapp`

```bash
pipenv run wagtail start webapp
```

## Modify the file and folder layout a little

> This is my preferred layout for a Wagtail project, it's not the same as the official docs.

Inside the `webapp` directory you can delete the following files as they are not used on PythonAnywhere:

- .dockerignore
- Dockefile
- requirements.txt

```bash
rm webapp/.dockerignore webapp/Dockerfile webapp/requirements.txt
```

Move the `manage.py` file to the root of the project:

```bash
mv webapp/manage.py .
```

Move the all the files and folders from the `webapp/webapp` directory up one level to the `webapp` directory:

```bash
mv webapp/webapp/* webapp
```

Delete the empty `webapp/webapp` directory:

```bash
rm -rf webapp/webapp
```

### Alter import paths and settings

Open `webapp/urls.py` and change the import path for

```python
from search import views as search_views
```

to

```python
from webapp.search import views as search_views
```

Open `webapp/settings/base.py` and change the app names for `home` and `search` in INSTALLED_APPS to:

```python
INSTALLED_APPS = [
    "webapp.home",
    "webapp.search",
    ...
]
```

The project file structure should look like this:

```tree
.
├── venv
├── webapp
│   ├── home
│   ├── search
│   ├── settings
│   ├── static
│   ├── templates
│   ├── __init__.py
│   ├── urls.py
│   └── wsgi.py
├── .gitignore
├── manage.py
├── Pipfile
├── Pipfile.lock
├── README.md
├── requirements.txt
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

> You can run `pipenv shell` to activate the virtual environment before running any of the manage.py commands.
>
> This will mean `pipenv run python manage.py migrate` can be run as `./manage.py migrate` for example.

The site is currently using sqlite3 database but later on it will be swapped out for a Mysql database.

Up Next - [Setup environment variables](./d-add-envvars.md)
