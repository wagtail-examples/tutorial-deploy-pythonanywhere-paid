# Create a Mysql database on PythonAnywhere

On the `Databases` tab create a new database. I called mine `nickmoreton_co_uk_db`

> As suggested it's best to add a new password for your database if you've not already done so.

## Add env vars on PythonAnywhere

Earlier on I created a .env file at `~/.env-settings/nickmoreton.co.uk`

Open the file, you can do this from the `Files` tab and add the following content.

```txt
MYSQL_DATABASE='the-datbase-name-you-just-created'
MYSQL_USER='get-this-from-the-databases-tab' # Username
MYSQL_PASSWORD='the-password-just-created'
MYSQL_HOST='get-this-from-the-databases-tab' # Database host address
MYSQL_PORT='3306'
```

While I am editing this file, although not Database related the following can be added.

```txt
WAGTAIL_SITE_NAME='add-your-sites-name'
BASE_URL='http://your-domain.co.uk'
DJANGO_SECRET_KEY='add-a-good-secret-key'
DJANGO_ALLOWED_HOSTS='your-domain.co.uk'
```

Save the file.

These values will be picked up when the webapp is first run and also when activating a virtual environment.

Up Next - [Update some web app settings](./h-update-some-webapp-settings.md)
