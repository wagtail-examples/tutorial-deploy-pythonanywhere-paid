#!/bin/bash

# Check if MySQL is running
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
    if [ "$MYSQL_RUNNING" = false ]; then
        docker-compose stop db
        echo "MySQL has been stopped."
    fi
    exit 0
else
    echo "Migrations are out of date. Please run 'pipenv run python manage.py makemigrations' and commit the changes."
    # If MySQL was not originally running, stop it before exiting
    if [ "$MYSQL_RUNNING" = false ]; then
        docker-compose stop db
        echo "MySQL has been stopped."
    fi
    exit 1
fi
