# Set up a webapp on PythonAnywhere

Once you have created your PythonAnywhere account, log into it.

Open the `web` tab and click the `Add a new web app` button.

Choose:

1. Own domain (I'm using a domain I own `www.nickmoreton.co.uk`)
2. Manual setup
3. Python (latest you can choose)

This will create the webapp and take you to the settings page for the webapp.

> I find it best to use the full domain, including `www` for the webapp name. Later on at my domain provider I set up web-forwarding from `nickmoreton.co.uk` to `www.nickmoreton.co.uk`
>
> It can take a while for DNS changes to be updated for the webapp so you could come back later and complete some of the following steps.

## Configure your domain name

Copy the CNAME details and add them to your domain at your providers control panel. [PA Help](https://help.pythonanywhere.com/pages/CustomDomains)

When the DNS changes have propagated you should add an `HTTPS certificate` and make it the default `Force HTTPS` enabled.

## Add directories for your webapp

> As it's possible to host multiple web apps in your PA account, think about naming when choosing your directory/file names

### Source code

Open the `Files` tab navigate to `/var/www/sites` which should already exist.

Create a directory to hold your source code. I named mine `nickmoreton.co.uk`, this is going to be my live/production website.

## Bare repos storage

Open the `Files` tab navigate to your home folder.

Create a directory to hold your bare-repos. I named mine `bare-repos` Then I added another directory inside bare-repos called `nickmoreton.co.uk.git`

## Environment variables storage

Open the `Files` tab navigate to your home folder.

Create a directory to hold your environment variables. I called mine `.env-settings` then I added another directory inside .env-settings called `nickmoreton.co.uk`

## Virtual Environments

You should create a virtual environment for each webapp. PA makes this straight forward. [PA Help](https://help.pythonanywhere.com/pages/Virtualenvs/)

### Create a virtual environment

Open the `Consoles` tab and open a new bash console.

Use `mkvirtualenv` to create a new virtual environment. I named mine `nickmoreton.co.uk_venv` and I'm using Python 3.10

```bash
mkvirtualenv nickmoreton.co.uk_venv --python=/usr/bin/python3.10
```

To confirm the virtual environment has been created run:

```bash
ls ~/.virtualenvs/nickmoreton.co.uk_venv/
> bin lib pyvenv.cfg
```

### Load environment variables when activating the virtual env

You can manually activate the virtual environment by running:

```bash
workon nickmoreton.co.uk_venv
```

Create a `.env` file in the environment variables directory created earlier:

```bash
touch ~/.env-settings/nickmoreton.co.uk/.env
```

Later we'll add some env vars to this file...

When you activate the virtual environment, environment variables can be loaded for you. You can set this up by running:

```bash
echo "set -a; source ~/.env-settings/nickmoreton.co.uk/.env; set +a" >> ~/.virtualenvs/nickmoreton.co.uk_venv/bin/postactivate
```

[PA help](https://help.pythonanywhere.com/pages/environment-variables-for-web-apps/#for-bash-consoles-load-your-env-file-in-your-virtualenv-postactivate-script) about environment variables

## Set up a git bare repo

A bare repo is the remote `production` I'll push my `main`  branch to to start a deployment. [A PA Blog Post](https://blog.pythonanywhere.com/87/) about bare repos.

Open the `Consoles` tab open a new console.

To initialize the bare repo for a webapp switch to the bare-repos directory:

```bash
cd ~/bare-repos/nickmoreton.co.uk.git/
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

then I opened the file in nano:

```bash
nano hooks/post-receive
```

and added the following content:

```bash
#!/bin/bash

while read oldrev newrev ref
do
if [[ $ref =~ .*/main ]];
then
    # only the main branch can be deployed

    # ensure the site directory exists
    mkdir -p /var/www/sites/nickmoreton.co.uk
    
    # checkout the latest version of the site
    git --work-tree=/var/www/sites/nickmoreton.co.uk --git-dir=/home/wtgi/bare-repos/nickmoreton.co.uk.git checkout -f main 
    
    # there will be more content added here later ...    
else
    echo "Ref $ref successfully received.  Doing nothing: only the main branch may be deployed on this server."
fi
done
```

### Make the post-receive hook executable

In the console run:

```bash
chmod +x ~/bare-repos/nickmoreton.co.uk.git/hooks/post-receive
```

To make the `post-receive` hook executable.

### Add the new remote to your local repository

> Substitute `my-account-name` with your own account name
>
> My account is in the EU so I need to use `ssh.eu.pythonanywhere.com`

On your local machine in the root of the project run::

```bash
git remote add production my-account-name@ssh.eu.pythonanywhere.com:/home/my-account-name/bare-repos/nickmoreton.co.uk.git
```

## Pushing to the remote repo

I'm going to push my `main` branch to the `production` remote repo.

```bash
git push production main
```

> If you are on another branch and accidentally try to push it to your production remote it will not complete and report the error.
>
> I can see the push has worked because in `/var/www/sites/nickmoreton.co.uk` I can see the new files.

The `post-receive` hook will manage the creation of the webapp directory if it doesn't exist and will copy across the current file changes to `/var/www/sites/nickmoreton.co.uk`

Up Next - [Python dependencies](./b-python-dependencies.md)
