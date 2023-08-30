# Set up a webapp and bare-repo on PythonAnywhere

Once you have created your PythonAnywhere account, log into it.

Open the `web` tab and click the `Add a new web app` button.

1. **Choose:** `Own domain` (or use the default given by PA) I used my own domain name here, I suggest you also specify `www` in the name or the subdomain you are using.
2. **Choose:** `Manual setup`
3. **Choose:** `Python` (latest you can choose)

This will create the webapp and take you to the settings page for the webapp.

> I find it best to use the full domain, including `www` for the webapp name. Later on at my domain provider I set up web-forwarding from `domain.com` to `www.domain.com` It can take a while for DNS changes to be updated for the webapp so you could come back later and complete some of the following steps.

## Configure your domain name

Copy the CNAME details and add them to your domain at your providers control panel. [PA Help](https://help.pythonanywhere.com/pages/CustomDomains)

When the DNS changes have propagated you should add an `HTTPS certificate` and make it the default `Force HTTPS` enabled.

## Setup directories

> As it's possible to host multiple web apps in your PA account, think about naming when choosing your directory/file names

Open the `Files` tab...

### Source code directory

Navigate to `/var/www/sites` which should already exist.

Create a directory to hold your source code. Something like `www.domain.com`, this is going to be my live/production website.

<!-- Return to the `webapp` settings page and scroll down to the `Code` section and set the `Source code` path to `/var/www/sites/www.domain.com` (or whatever you named your source code directory) -->

### Bare repos directory

Set up a directory structure to hold your bare repos.

Navigate to your home folder e.g. `/home/account-name`

Create a directory inside to hold your bare-repos. I named mine `bare-repos` Then I add another directory inside bare-repos something like `www.domain.com.git`

So the path to the bare repo directory is `/home/account-name/bare-repos/www.domain.com.git`

### Environment variables storage

Navigate to your home folder e.g. `/home/account-name`

Create a directory to hold your environment variables. I called mine `.env-settings` then I added another directory inside it called `www.domain.com`

So the path to the environment variables directory is `/home/account-name/.env-settings/www.domain.com`

## Create a virtual environment

Open the `Consoles` tab and open a new bash console.

You should create a virtual environment for each webapp. PA makes this straight forward. [PA Help](https://help.pythonanywhere.com/pages/Virtualenvs/)

Use `mkvirtualenv` to create a new virtual environment for this site. I named mine `www.domain.com.venv` and I'm using Python 3.10

```bash
mkvirtualenv www.domain.com.venv --python=/usr/bin/python3.10
```

To confirm the virtual environment has been created run:

```bash
ls ~/.virtualenvs/www.domain.com.venv/
> bin lib pyvenv.cfg
```

### Load environment variables when activating the virtual env

> You can manually activate the virtual environment by running:

```bash
workon www.domain.com.venv
```

Create a `.env` file in the environment variables directory created earlier:

```bash
touch ~/.env-settings/www.domain.com/.env
```

> Later we'll add some env vars to this file...

When you activate the virtual environment, environment variables can be loaded for you. You can set this up by running:

```bash
echo "set -a; source ~/.env-settings/www.domain.com/.env; set +a" >> ~/.virtualenvs/www.domain.com.venv/bin/postactivate
```

[PA help](https://help.pythonanywhere.com/pages/environment-variables-for-web-apps/#for-bash-consoles-load-your-env-file-in-your-virtualenv-postactivate-script) about environment variables

## Set up a git bare repo

A bare repo is the remote I'll push my `main`  branch to to start a deployment. [A PA Blog Post](https://blog.pythonanywhere.com/87/) about bare repos.

Open the `Consoles` tab open a new console ro use the console from the previous step.

To initialize the bare repo for a webapp switch to the bare-repos directory:

```bash
cd ~/bare-repos/www.domain.com.git/
```

and run:

```bash
git init --bare
```

[Stack Overflow](https://stackoverflow.com/questions/7632454/how-do-you-use-git-bare-init-repository) How do you use "git --bare init" repository?

### Create a post-receive hook

While still in the `bare-repos` directory for your site:

Create a `post-receive` hook file:

```bash
touch hooks/post-receive
```

then I opened the file in nano (you could open if from the Files tab):

```bash
nano hooks/post-receive
```

and added the following content (substitute `account-name` with your own account name and `www.domain.com` with your own domain name):

```bash
#!/bin/bash

while read oldrev newrev ref
do
if [[ $ref =~ .*/main ]];
then
    # only the main branch can be deployed

    # ensure the site directory exists
    mkdir -p /var/www/sites/www.domain.com
    
    # checkout the latest version of the site
    git --work-tree=/var/www/sites/www.domain.com --git-dir=/home/account-name/bare-repos/www.domain.com.git checkout -f main 
    
    # there will be more content added here later ...    
else
    echo "Ref $ref successfully received.  Doing nothing: only the main branch may be deployed on this server."
fi
done
```

### Make the post-receive hook executable

In the console run:

```bash
chmod +x ~/bare-repos/www.domain.com.git/hooks/post-receive
```

## Create a Mysql database on PythonAnywhere

On the `Databases` tab create a new database. I called mine `www_domain_com_db`. PythonAnywhere prepends your account name to the database name followed by a $. So my database name is `account-name$www_domain_com_db`

> As suggested it's best to add a new password for your database if you've not already done so.

## Add env vars on PythonAnywhere

Earlier on I created a .env file at `~/.env-settings/www.domain.com/.env`

Open the file, you can do this from the `Files` tab and add the following content, substituting the values for your own:

```sh
MYSQL_DATABASE='account-name$www_domain_com_db'
MYSQL_USER='account-name' # Username
MYSQL_PASSWORD='the-password-just-created'
MYSQL_HOST='get-this-from-the-databases-tab' # Database host address
MYSQL_PORT='3306'
```

While I am editing this file, although not Database related the following can be added.

```sh
WAGTAIL_SITE_NAME='add-your-sites-name'
BASE_URL='http://www.domain.com'
DJANGO_SECRET_KEY='add-a-good-secret-key'
DJANGO_ALLOWED_HOSTS='www.domain.com'
```

Save the file.

These values will be picked up when the webapp is first run and also when activating a virtual environment.

Up Next - [Add further deployment settings](./200-2-deploy-hooks-wsgi.md)
