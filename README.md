# Building and deploying a Wagtail CMS site to PythonAnywhere

The official [Wagtail documentation](https://wagtail.org) is excellent and I suggest you read the [Developer Documentation](https://docs.wagtail.org/en/stable/), specifically the [Your first wagtail site](https://docs.wagtail.org/en/stable/getting_started/tutorial.html) but I wanted to document the process I go through to build a Wagtail site from scratch.

I'm going to build a site for myself, [nickmoreton.co.uk](https://nickmoreton.co.uk). I'm not sure yet what I'm going to put on it, but I'll figure that out as I go along. This tutorial could be a good first piece of content for it. 😀

I've actually built and deployed a fair few Wagtail sites over the last decade, as a freelancer and I now work for [Torchbox](https://torchbox.com) as a developer.

This is the process I go through to build a Wagtail site from scratch, thats been done before and is nothing new but I want to include deploying the site to PythonAnywhere as well, in a semi automated way. Any ideas here could be used to deploy to other hosting platforms as well. I'd describe PythonAnywhere as a managed linux server with a web interface for convenience.

Because I'll use git to deploy the webapp and that requires SSH access, I need to use the paid for version of PythonAnywhere, which starts at €5/month. You could use a free account but you'll need to do your deployments manually and use `git pull` to update the code.

The tech stack so far is:

- ✅ Python:3.10
- ✅ Mysql:5.7 (this is a limitation of PythonAnywhere)
- Node / webpack to build the frontend
- CI actions for code checks
- Pre-commit to run git hooks
- ✅ Git push deployments to PythonAnywhere (like Heroku etc.)
- ✅ Wagtail CMS v5.1.1
- ✅ Django 4.1 (Mysql 5.7 requires Django < 4.2)

The finished source code for the live site is here [https://github.com/nickmoreton/nickmoreton.co.uk](https://github.com/nickmoreton/nickmoreton.co.uk) on the `main` branch and will become more complete over time.

## Contents

- [Create a git repo to store the source code](./docs/a-1-create-a-origin-repo.md)
- [Set up a webapp on PythonAnywhere](./docs/a-2-create-a-webapp.md)
- [Python dependencies](./docs/b-python-dependencies.md)
- [Start a Wagtail site](./docs/c-wagtail-start.md)
- [Setup environment variables](./docs/d-add-envvars.md)
- [Add a local mysql docker container for development](./docs/e-add-mysql-docker.md)
- [Configure Wagtail to use the Mysql database](./docs/f-switch-to-mysql.md)
- Up and running locally...
- [Create a Mysql database on PythonAnywhere](./docs/g-create-mysql-on-pythonanywhere.md)
- [Update some web app settings on PythonAnywhere](./docs/h-update-some-webapp-settings.md)
- [Alter Wagtail settings to use more environment variables](./docs/i-alter-settings-extra-vars.md)
- [Add further steps to the post-recieve hook](./docs/j-add-further-deploy-hooks.md)
- [Update the WSGI file on PythonAnywhere](./docs/k-update-the-wsgi-file.md)
- [Start a deployemnt](./docs/l-push-to-the-bare-repo.md)
- Up and running on PythonAnywhere...
- [Some TODO's](./docs/m-todos.md)

Up Next - [Create a git repo to store the source code](./docs/a-1-create-a-origin-repo.md)
