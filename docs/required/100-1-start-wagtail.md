# Initial repo and starting a new Wagtail project

Create a new repo on your preferred provider. Github can add some files for you when starting a new project, I decided to add a `README` file and a `gitignore` file for `Python`.

Clone the newly created repo to your local development machine. It will have a remote called `origin`.

> Later on I'll create a remote called `production` which I'll use to deploy the site to PythonAnywhere.

## Python dependencies

There are a few ways to manage python dependencies, I'm using [Pipenv](https://pipenv.pypa.io/en/latest/) but you can use your preferred method. The only caveat is that the production dependencies ideally need to be in a `requirements.txt` file when deploying to PythonAnywhere.

With [Pipenv](https://pipenv.pypa.io/en/latest/) installed run:

```bash
pipenv install "wagtail>=5.1,<5.2" "mysqlclient>=2.2,<2.3" "python-dotenv>=1.0,<1.1" "django>=4.1,<4.2"
```

> I'm using Django v4.1 as my PythonAnywhere account uses Mysql v5.7 and Django v4.2+ requires Mysql v8.0+. If your account uses Mysql v8.0+ then you can omit the Django constraint.

Then create an initial requirements file with:

```bash
pipenv requirements > requirements.txt
```

## Start a Wagtail site

If you don't have one already, add a .gitignore file so we don't commit anything we shouldn't.

A good example of a python .gitignore file is [https://github.com/github/gitignore/blob/main/Python.gitignore](https://github.com/github/gitignore/blob/main/Python.gitignore)

The .gitignore file should also contain the following at this stage.

```.gitignore
/media
```

Now create the initial Wagtail site called `webapp` or use your preferred name.

```bash
pipenv run wagtail start webapp
```

### Modify the file and folder layout a little

> I like to alter the layout of the files and folders a little to suit my preferences. It's not necessary but I find it easier to work with. You can skip this step if you prefer but make sure you adjust any paths in the following steps.

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

Run the Wagtail project locally to check that everything is working as expected, `activate` the virtual environment e.g. `pipenv shell` and run the following commands:

```bash
python manage.py migrate
python manage.py createsuperuser
```

Then run the local development server:

```bash
python manage.py runserver
```

Open a browser and go to <http://localhost:8000> and you should see the default Wagtail home page.

Open a browser and go to <http://localhost:8000/admin/> and login with the superuser credentials you just created.

The site is currently using sqlite3 database but later on it will be swapped out for a Mysql database.

Up Next - [Swap database to use Mysql](./100-2-use-mysql.md)
