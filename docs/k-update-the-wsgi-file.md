# Update the WSG file on PythonAnywhere

When a new webapp is created a WSGI file is automatically created with some example content. You can ignore and delete the content and add the following modified version of the example `# +++++++++++ DJANGO +++++++++++` section.

Update the paths and file names as appropriate for your own site.

```python
import os
import sys
from dotenv import load_dotenv # this was installed via requirements.txt

# use your own site path
path = '/var/www/sites/nickmoreton.co.uk'
if path not in sys.path:
    sys.path.append(path)

# use your own path for the env settings
env_folder = os.path.expanduser('~/.env-settings/nickmoreton.co.uk')
load_dotenv(os.path.join(env_folder, '.env'))

# assumes your webapp is called webapp, substitute as appropriate
os.environ['DJANGO_SETTINGS_MODULE'] = 'webapp.settings.production'

from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
```

Save the file.

Up Next - [Start a deployemnt](./l-push-to-the-bare-repo.md)
