# Alter Wagtail settings to use more environment variables

On your local machine, open `webapp/settings/base.py` and add/update the following:

```python
### existing code
env_vars = os.environ.copy()
### end existing code

### add this code block
if "DJANGO_SECRET_KEY" in env_vars:
    SECRET_KEY = env_vars["DJANGO_SECRET_KEY"]

if "DJANGO_ALLOWED_HOSTS" in env_vars:
    ALLOWED_HOSTS = env_vars["DJANGO_ALLOWED_HOSTS"].split(",")
    
### Find WAGTAIL_SITE_NAME = "webapp" and change is to...
WAGTAIL_SITE_NAME = env_vars["WAGTAIL_SITE_NAME"] if "WAGTAIL_SITE_NAME" in env_vars else ""

### WAGTAILADMIN_BASE_URL = "http://example.com" and change it to ...
WAGTAILADMIN_BASE_URL = env_vars["BASE_URL"] if "BASE_URL" in env_vars else ""
```

Open your local .env.example file and add these new environment variables, also make sure they are available in the .env file

```txt
WAGTAIL_SITE_NAME=site-name
BASE_URL=http://localhost:8000
DJANGO_SECRET_KEY=not-so-secret_key
DJANGO_ALLOWED_HOSTS=localhost
```

In local development they will be picked up by Pipenv and passed to the webapp when it's run. Try out the webapp locally to make sure all is working OK. Most of these settings will be overridden in dev.py when using runserver so probably won't make any difference.

In production, on a live site they will be loaded from that environment.

Up Next - [Add further steps to the post-recieve hook](./j-add-further-deploy-hooks.md)
