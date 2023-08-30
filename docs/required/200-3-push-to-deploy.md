# Start a deployment

First `git add` the file changes made so far and `git commit` them. For the moment I'm working directly on my `main` branch. In the future I'll be working on other branches and merging them to `main` for running a deployment.

You should push to the `origin` repo first e.g.:

```bash
git push origin main
```

## Add the new remote to your local repository

> Substitute `account-name` with your own account name. My account is in the EU so I need to use `ssh.eu.pythonanywhere.com`

On your local machine in the root of the project run::

```bash
git remote add production account-name@ssh.eu.pythonanywhere.com:/home/account-name/bare-repos/www.domain.com.git
```

> I'm using `production` as the name of the remote repo. You can use any name you like.

## Pushing to the remote repo (will start a deployment)

I'm going to push my `main` branch to the remote repo.

```bash
git push production main
```

Earlier on, in the `post-receive` hook I added a check to ensure only the `main` branch can be deployed. If you are on another branch and accidentally try to push it to your production remote it will not complete and report the error.

- I can see the push has worked because in `/var/www/sites/www.domain.com` I can see the new files.
- The `post-receive` hook will manage the creation of the webapp directory if it doesn't exist and will copy across the current file changes to `/var/www/sites/wwww.domain.com`
- If all is well you should see the deployment steps displayed in your console.
- On the first deployment it can take a few minutes to complete. Subsequent deployments usually take less time.
- In the `post-receive` hook, the `touch` command on the WSGI file will reload the webapp, it can take a minute or so to actually run on PythonAnywhere.

If you now visit your webapp url it should be live.

## Create a superuser on PythonAnywhere (optional and only required one time)

Open the `Web` tab on PythonAnywhere.

Under the `Virtualenv` section click `Start a console in this virtualenv` to open a new console in the sites virtual env. (Your environment variables are loaded automatically for you because the virtual env will be activated)

And run:

```bash
./manage.py createsuperuser
```

If you now visit webapp and login at `/admin` you should be able to test out the default Wagtail CMS
