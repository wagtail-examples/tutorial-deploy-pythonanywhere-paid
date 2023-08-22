# Add CI checks for migrations and requirements

The requirements and migrations files are checked by pre-commit when you commit new work. It's also possible to run these checks in CI.

## Check requirements

Create a new file `.github/workflows/test-requirements.yml` with the following content:

```yaml
name: check requirements

on:
  push:
    branches:
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

This workflow will run on every push to a branch that is not `main` and on every pull request to `main`.

## Check migrations

Create a new file `.github/workflows/test-migrations.yml` with the following content:

```yaml
name: check migrations

on:
  push:
    branches:
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

This workflow will run on every push to a branch that is not `main` and on every pull request to `main`.

> Note: This workflow uses a MySQL database. If you use a different database, you need to change the service configuration.
>
> Each workflow is a separate file but this probably isn't the best way to organize them. You can create a single file with multiple workflows. See [GitHub Actions documentation](https://docs.github.com/en/actions/learn-github-actions/introduction-to-github-actions#workflows) for more information.

**The End**, for now...
