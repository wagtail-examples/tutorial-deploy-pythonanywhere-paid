# Set up pre-commit and CI actions

*This step is entirely optional but is recommended.*

## Pre-commit

[Pre-commit](https://pre-commit.com) is a tool that runs git hooks on your code before you commit it. It's a great way to ensure your code is formatted correctly and passes some basic checks before you commit it.

It will run `black`, `isort` and `flake8` on my code and check for missing `migrations` and also that `requirements.txt` is up to date before I commit it.

### Install pre-commit

Add pre-commit to the development dependencies in `Pipfile`:

```bash
pipenv install --dev pre-commit
```

> If you already have pre-commit installed globally, you can skip this step.

### Configure pre-commit

Create a `.pre-commit-config.yaml` file in the root of the project:

```yaml
repos:
  # These hooks make sure that the code is formatted correctly
  - repo: https://github.com/pycqa/isort
    rev: 5.12.0
    hooks:
      - id: isort
  - repo: https://github.com/psf/black
    rev: 23.7.0
    hooks:
      - id: black
  - repo: https://github.com/pycqa/flake8
    rev: 6.1.0
    hooks:
      - id: flake8

  # These hooks make sure that the requirements.txt file is up to date
  # with the latest changes to pipenv as well as making sure migrations
  # are up to date.
  - repo: local
    hooks:
      - id: check-dependencies
        name: Check dependencies
        entry: ./checks/dependencies.sh
        language: system
        types: [python]
        pass_filenames: false
        always_run: true
        stages: [pre-commit]
      - id: check-migrations
        name: Check migrations
        entry: ./checks/migrations.sh
        language: system
        types: [python]
        pass_filenames: false
        always_run: true
        stages: [commit]
      - id: check-static
        name: Check static files
        entry: ./checks/static.sh
        language: system
        types: [css, javascript]
        pass_filenames: false
        always_run: true
        stages: [pre-commit]
```

### Add the git hook entry points

Create a `checks` directory in the root of the project and add the following files:

```bash
mkdir checks
touch checks/dependencies.sh
touch checks/migrations.sh
touch checks/static.sh
chmod +x checks/*.sh
```

Update the content of each file as follows:

File `checks/dependencies.sh`:

```bash
#!/bin/bash

# Get the contents of requirements.txt
requirements=$(cat requirements.txt)

# Get the output from pipenv requirements
pipenv_requirements=$(pipenv requirements)

# Compare the two outputs
if [ "$requirements" == "$pipenv_requirements" ]; then
  echo "Requirements are correct"
else
  echo "Requirements are different, please run pipenv requirements > requirements.txt and stage the changes"
  exit 1
fi
```

File `checks/migrations.sh`:

```bash
#!/bin/bash

# Check if MySQL is already running
# so we can stop it after the checks if it was started here.
if docker-compose top | grep mysqld 2> /dev/null; then
    echo "MySQL is running."
    MYSQL_RUNNING=true
else
    echo "MySQL is not running."
    MYSQL_RUNNING=false
fi

if [ "$MYSQL_RUNNING" = false ]; then
    docker-compose up -d db
    echo "MySQL has been started."
fi

if pipenv run python manage.py makemigrations --check --dry-run; then
    # There are no changes to migrations
    if [ "$MYSQL_RUNNING" = false ]; then
        docker-compose stop db
        echo "MySQL has been stopped."
    fi
    exit 0
else
    # There are changes to migrations
    echo "Migrations are out of date. Please run 'pipenv run python manage.py makemigrations' and commit the changes."
    # If MySQL was not originally running, stop it before exiting
    if [ "$MYSQL_RUNNING" = false ]; then
        docker-compose stop db
        echo "MySQL has been stopped."
    fi
    exit 1
fi
```

File `checks/static.sh`:

```bash
#!/bin/bash

# This script generates production-ready files for the scripts and styles
# It runs npm run build
# If files are changed then fails

# Exit on error
set -e

# Run npm run build
npm run build
```

### Use Pipenv to install some development dependencies

```bash
pipenv install --dev black==23.7.0 pre-commit==3.3.3 flake8==6.1.0 isort==5.12.0 tomli==2.0.1
```

I've pinned the versions of the development dependencies to the same versions as the pre-commit hooks.

### Install the pre-commit hooks

```bash
pipenv run pre-commit install
```

> You can use the `pre-commit install` command to initialize pre-commit. You can also run `pre-commit uninstall` to remove the hooks.

### Run the pre-commit hooks

```bash
pipenv run pre-commit run --all-files
```

> if this is the first time you'll probably see some file changes have been made. You can commit these changes and then run the pre-commit hooks again to make sure everything is ok.

### Commit the changes

```bash
git add .
git commit -m "add your commit message here"
```

> Having pre-commit installed means that every time you commit code, the pre-commit hooks will run and check your code. If there are any errors, the commit will fail and you'll need to fix the errors before you can commit again.
>
> Make sure you have stopped the npm server before you commit, the one you started with `npm start`.
