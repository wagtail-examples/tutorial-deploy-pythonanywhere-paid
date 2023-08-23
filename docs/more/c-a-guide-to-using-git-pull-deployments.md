# A guide to using git pull deployments

I've not covered this in this tutorial but it's possible to use git pull deployments on PythonAnywhere. You can still use this tutorial to get up and running but you'll need to do your deployments from a console on PythonAnywhere using `git pull`.

## Roughly: You'd need to follow these steps

- [Set up a webapp on PythonAnywhere](../a-1-create-a-origin-repo.md)
- [Python dependencies](../b-python-dependencies.md)
- [Start a Wagtail site](../c-wagtail-start.md)
- [Setup environment variables](../d-add-envvars.md)
- [Add a local mysql docker container for development](../e-add-mysql-docker.md)
- [Configure Wagtail to use the Mysql database](../f-switch-to-mysql.md)
- Up and running locally...
- [Create a Mysql database on PythonAnywhere](../g-create-mysql-on-pythonanywhere.md)
- [Update some web app settings on PythonAnywhere](../h-update-some-webapp-settings.md)
- [Alter Wagtail settings to use more environment variables](../i-alter-settings-extra-vars.md)
- [Update the WSGI file on PythonAnywhere](../k-update-the-wsgi-file.md)
- Git pull your code...

But not set up the bare-repo and post-receive hook.
