# Setup environment variables

To handle the configuration of the Wagtail app and make it convenient to run the app locally and in production I'll set up some environment variables.

## Add a .env file which we can safely push to a git repo

```bash
touch .env.example
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

Copy file to `.env`

```bash
cp .env.example .env
```

Before you commit the `.env` file to git, add it to the `.gitignore` file so in the future there's less risk of committing secrets to git:

```bash
echo ".env" >> .gitignore
```

Up Next - [Add a local mysql docker container for development](./e-add-mysql-docker.md)
