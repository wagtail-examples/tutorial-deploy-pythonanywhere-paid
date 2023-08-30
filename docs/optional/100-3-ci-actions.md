# Github actions

[Git Hub CI actions](https://docs.github.com/en/actions) are a way to automate tasks on your code. You can use them to run tests, check code style, deploy code and much more.

*The code samples below are for use with Github Actions. If you use a different provider, you'll need to check their documentation for how to set up CI scripts.*

## Create a CI action to run the code-style checks

Create a `.github/workflows/test-codestyle.yml` file and add the following code:

```yaml
name: check code style

on:
  push:
    branches:
      - '!main' # will run on all branches except the main branch
      
  pull_request:
    branches:
      - main # will run on pull requests to the main branch

jobs:
  code-style:
    name: Code Style
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0

      - name: Set up Python 3.10
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'

      - name: Install Dependencies
        # uses pipenv to install the dependencies incl. dev dependencies
        run: |
          python -m pip install --upgrade pip
          python -m pip install pipenv
          pipenv install --dev --deploy

      - name: Flake8
        run: pipenv run flake8 ./

      - name: Isort
        run: pipenv run isort ./ --check

      - name: Black
        run: pipenv run black ./ --check
    
    # I'll be adding more checks here later on
```

## Create a CI action to run the migrations check

Create a `.github/workflows/test-migrations.yml` file and add the following code:

```yaml
name: check migrations

on:
  push:
    branches:
      - '**'
      - '!main'
      
  pull_request:
    branches:
      - main

jobs:

  check-migrations:
    name: Check migrations
    runs-on: ubuntu-latest
    services:
      mysql:
        image: mysql:5.7
        env:
          MYSQL_ROOT_PASSWORD: root
          MYSQL_DATABASE: test
        options: >-
          --health-cmd "mysqladmin ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
        - 3306:3306
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Set up Python
        id: setup-python
        uses: actions/setup-python@v4
        with:
          python-version: "3.10"

      - name: Set checks as executable
        run: chmod +x ./checks/*.sh

      - name: Install dependencies
        id: install-dependencies
        run: |
          python -m pip install --upgrade pip
          python -m pip install pipenv
          pipenv install --dev --deploy

      - name: Check migrations
        run: ./checks/migrations.sh
        env:
          MYSQL_ROOT_PASSWORD: root
          MYSQL_DATABASE: test
          MYSQL_USER: root
          MYSQL_PASSWORD: root
          MYSQL_ROOT_HOST: '%'
          MYSQL_HOST: 127.0.0.1
          MYSQL_PORT: 3306
```

## Create a CI action to run the requirements check

Create a `.github/workflows/test-requirements.yml` file and add the following code:

```yaml
name: check requirements

on:
  push:
    branches:
      - '**'
      - '!main'
      
  pull_request:
    branches:
      - main

jobs:
  test-requirements:
    runs-on: ubuntu-latest
    name: Check requirements
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Set up Python
        id: setup-python
        uses: actions/setup-python@v4
        with:
          python-version: "3.10"

      - name: Set checks as executable
        run: chmod +x ./checks/*.sh

      - name: Install dependencies
        id: install-dependencies
        run: |
          python -m pip install --upgrade pip
          python -m pip install pipenv
          pipenv install --dev --deploy

      - name: Check requirements
        run: ./checks/dependencies.sh
```

## Create a CI action to run the static files check

Create a `.github/workflows/test-static.yml` file and add the following code:

```yaml
name: check static assets

on:
  push:
    branches:
      - '**'
      - '!main'
      
  pull_request:
    branches:
      - main

jobs:
  static-assets:
    name: Static Assets
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Set up Node.js
        uses: actions/setup-node@v3
        with:
          node-version: 18

      - name: Set checks as executable
        run: chmod +x ./checks/*.sh

      - name: Install dependencies
        id: install-dependencies
        run: |
          npm ci

      - name: Check static
        run: ./checks/static.sh
```

I've intentionally used individual actions for each check so that you can choose the ones you need. You could add each job in a single file if you prefer.
