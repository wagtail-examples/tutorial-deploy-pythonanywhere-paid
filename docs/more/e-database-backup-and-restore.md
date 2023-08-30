# Database backup and restore

When developing new features, it's useful to have some real data to work with. You could add data locally but it can take time to create it. It's possible to backup the database and media files from the live site and restore them locally. Also useful is [Media files backup and restore](./f-media-files-backup-and-restore.md).

- `*your-account-name*` = your PythonAnywhere account name
- `*your-database-name*` = the name of your database
- replace `mysql.eu.pythonanywhere-services.com` with the mysql server name for your account
- replace `ssh.eu.pythonanywhere.com` with the ssh server name for your account

## Backup the database

These commands can be used to backup the database on PythonAnywhere.

Open a console on PythonAnywhere and run the following command:

```bash
ssh *your-account-name*@ssh.eu.pythonanywhere.com
```

Create a directory to store the backups:

```bash
mkdir -p ~/dbbackups
```

Then run the following command to backup the database:

> If you're using a PythonAnywhere account where the Mysql version is 5.7 you won't need use `--column-statistics=0` but if you're using Mysql version 8 you will.

```bash
mysqldump -u *your-account-name* -h *your-account-name*.mysql.eu.pythonanywhere-services.com --set-gtid-purged=OFF --no-tablespaces --column-statistics=0 '*your-database-name*' > ~/dbbackups/*your-database-name*.sql
```

Exit the console:

```bash
exit
```

To pull the database backup to your local machine:

First cd into the project directory:

```bash
cd ~/PythonAnywhere/your-project-directory
```

Then run the following command:

```bash
scp *your-account-name*@ssh.eu.pythonanywhere.com:~/dbbackups/*your-database-name*.sql ./dbbackups/*your-database-name*.sql
```

**Update your .gitignore file** so the backups don't get committed, to ignore the database backup directory (dbbackups) run the following commend:

```bash
echo "/dbbackups" >> .gitignore
```

## Restore the database to your local machine

You'll need to make sure the docker instance of `Mysql` is running locally.

> If you database name is different then substitute `webapp` for your database name.

Open the `docker-compose.yml` file and add a new location of `./dbbackups:/dbbackups` to the `volumes` section:

```yaml
volumes:
  - dbdata:/var/lib/mysql
  - ./dbbackups:/dbbackups # add this line
```

> When you run docker-compose up again the directory and contents will be copied into the container.

Then run the following commands:

```bash
docker-compose up -d
# drop the existing database
docker-compose exec db mysql -u root -p -e "drop database webapp"
# create a new database
docker-compose exec db mysql -u root -p -e "create database webapp"
# import the database backup, it was copied form the local machine to the container
docker-compose exec db bash -c "mysql -u root -p webapp < /dbbackups/*your-database-name*.sql"
```

If you have `Adminer` running locally you can use that to drop the database, create it again and import the backup.
