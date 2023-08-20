# Start a deployment

First `git add` the file changes made so far and `git commit` them. For the moment I'm working directly on my `main` branch. In the future I'll be working on other branches and merging them to `main` for a deployemnt.

You should push to the `origin` repo first e.g.:

```bash
git push origin main
```

and then push to the `production` bare-repo to start the deployemnt.

```bash
git push production main
```

If all is well you should see the deployment steps displayed in your console. On the first deployemnt is can take a few minutes to complete. Subsequent deployments may take less time.

> Although we use the `touch` command on the WSGI file to reload the webapp it can take a minute or so to actually run on PythonAnywhere.

If you now visit your webapp url it should be live.

## Create a superuser on PythonAnywhere

Open the `Web` tabs on PythonAnywhere.

Under the `Virtualenv` section click `Start a console in this virtualenv` to open a new console in the sites virtual env. (Your environment variables are loaded automatically for you because the virtual env will be activated)

And run:

```bash
./manage.py createsuperuser
```

If you now visit webapp and login at `/admin` you should be able to test out the default Wagtail CMS

Up Next - [Some TODO's](./m-todos.md)
