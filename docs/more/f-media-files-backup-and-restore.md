# Media files backup and restore

These commands can be used to copy the media files from the live site to your local machine.

- `*your-account-name*` = your PythonAnywhere account name
- replace `ssh.eu.pythonanywhere.com` with the ssh server name for your account

First cd into the project directory on your local machine:

```bash
cd ~/PythonAnywhere/nickmoreton.co.uk # use your own project directory
```

Ensure the media directory exists:

```bash
mkdir -p ./media
```

Then run the following command:

```bash
scp -r *your-account-name*@ssh.eu.pythonanywhere.com:/var/www/sites/nickmoreton.co.uk/media ./
```
