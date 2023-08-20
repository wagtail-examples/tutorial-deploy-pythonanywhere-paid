# Add further steps to the post-recieve hook

Earlier I created a post-receive hook: `~/bare-repos/nickmoreton.co.uk.git/hooks/post-receive` open the file and add the following extra steps.

Replace: `# there will be more content added here later ...` with the following, make adjustments for your own paths file names:

```bash
# switch to site directory
cd /var/www/sites/nickmoreton.co.uk
source /usr/local/bin/virtualenvwrapper.sh
# and activate the virtual environment
workon nickmoreton.co.uk_venv

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
touch /var/www/www_nickmoreton_co_uk_wsgi.py
```

These steps will install any new/updated requirements and run the necessary Django commands.

The last command `touch` will restart the webapp so that any changes are loaded.

Up Next - [Update the WSG file on PythonAnywhere](./k-update-the-wsgi-file.md)
