# Add further deployment settings

## Deploy hooks (post-receive)

Earlier I created a post-receive hook: `~/bare-repos/www.domain.com.git/hooks/post-receive` open the file (use the files tab to locate it and open it in the editor) and add the following extra steps.

Replace: `# there will be more content added here later ...` with the following, make adjustments for your own paths and/or file names:

```bash
# there will be more content added here later ...

# Replace the above with ...

# switch to site directory
cd /var/www/sites/www.domain.com
source /usr/local/bin/virtualenvwrapper.sh
# and activate the virtual environment
workon www.domain.com.venv

# install/update requirements
echo "INSTALL REQUIREMENTS"
pip install -r requirements.txt

# run migrations
echo "RUN MIGRATIONS"
python manage.py migrate --no-input

# add/update static files
echo "COLLECT STATIC FILES"
python manage.py collectstatic --no-input

# reload the web app by touching the wsgi file
echo "RELOAD THE WEB APP"
touch /var/www/www_domain_com_wsgi.py
```

These steps will install any new/updated requirements and run the necessary Django commands.

The last command `touch` will restart the webapp so that any changes are loaded.

Save the file.

## Update the WSG file on PythonAnywhere

From the `Web` tab open the `WSGI configuration file` for your site.

When a new webapp is created a WSGI file is automatically created with some example content. You can delete all the content and add the following modified version of the example `# +++++++++++ DJANGO +++++++++++` section.

Add this python code to your sites WSGI file, update the paths and file names as appropriate for your own site.

```python
import os
import sys
from dotenv import load_dotenv # this was installed via requirements.txt

# use your own site path
path = '/var/www/sites/www.domain.com'
if path not in sys.path:
    sys.path.append(path)

# use your own path for the env settings
env_folder = os.path.expanduser('~/.env-settings/www.domain.com')
load_dotenv(os.path.join(env_folder, '.env'))

# assumes your webapp is called webapp, substitute as appropriate
os.environ['DJANGO_SETTINGS_MODULE'] = 'webapp.settings.production'

from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
```

Save the file.

Add further deployment settings

Up Next - [Start a deployment](./200-3-push-to-deploy.md)
