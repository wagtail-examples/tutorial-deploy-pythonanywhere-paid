# How to setup sending emails

Outbound emails are useful for at least password reminders but more so for notifications if using the Wagtail Form Builder. There's lots of 3rd party services that can be used for this. But for small sites SMTP from your email provider should be fine.

It could be as easy as adding the following to the `settings/base.py` file:

```python
# EMAIL
EMAIL_HOST = env_vars["EMAIL_HOST"] if "EMAIL_HOST" in env_vars else ""
EMAIL_PORT = env_vars["EMAIL_PORT"] if "EMAIL_PORT" in env_vars else ""
EMAIL_HOST_USER = env_vars["EMAIL_HOST_USER"] if "EMAIL_HOST_USER" in env_vars else ""
EMAIL_HOST_PASSWORD = env_vars["EMAIL_HOST_PASSWORD"] if "EMAIL_HOST_PASSWORD" in env_vars else ""
EMAIL_SENDER_ADDRESS = env_vars["EMAIL_SENDER_ADDRESS"] if "EMAIL_SENDER_ADDRESS" in env_vars else ""
```

And then adding the environment variables to the `.env` file created here [Setup environment variables](../a-2-create-a-webapp.md#environment-variables-storage)
