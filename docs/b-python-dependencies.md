# Python dependencies

Open your project on your local machine.

I'm using `Pipenv` to manage the python dependencies, Pipenv isn't used on PythonAnywhere. Production dependencies will be in `requirements.txt`

With [Pipenv](https://pipenv.pypa.io/en/latest/) installed run:

```bash
pipenv install "wagtail>=5.1,<5.2" "mysqlclient>=2.2,<2.3" "python-dotenv>=1.0,<1.1"
```

Then create the requirements file with:

```bash
pipenv requirements > requirements.txt
```

Up Next - [Start a Wagtail site](./c-wagtail-start.md)
