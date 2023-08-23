# A backup strategy

It's possible to add a scheduled task in PythonAnywhere to run a script that backs up the database and uploads it to a cloud storage provider like AWS S3. You could also backup the media files in the same way.

See [Database backup and restore](./e-database-backup-and-restore.md#database-backup-and-restore) for how to prepare database backups. The command could be adjusted to generate a timestamped backup that can the be uploaded to S3 storage.

> I use [Linode Object Storage](https://www.linode.com/products/object-storage/) for backup file storage.
