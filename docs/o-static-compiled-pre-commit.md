# Use pre-commit to ensure static assets are production ready

So far we've used `npm start` to compile the frontend assets they are not really production ready. We need to minify the CSS and JS.

You could run `npm run build` to do this but I want to automate this process so that it happens on every commit and I'll never forget to do it.

## Update the pre-commit config

Add the following to the `.pre-commit-config.yaml` file:

```yaml
      - id: check-static
        name: Check static files
        entry: ./checks/static.sh
        language: system
        types: [css, javascript]
        pass_filenames: false
        always_run: true
        stages: [pre-commit]
```

*Make sure the indentation is correct.*

## Add a static check script

Create a file `checks/static.sh` with the following content:

```bash
touch checks/static.sh && chmod +x checks/static.sh
```

Add the following content to the file:

```bash
#!/bin/bash

# This script generates production-ready files for the scripts and styles.
# It runs npm run build and generates the files in webapp/static/webapp
# If files are changed pre-commit will output a warning message.
# You should commit the changes.

# Exit on error
set -e

# Run npm run build
npm run build
```

## Add a CI action to check the static files

If you don't have pre-commit initialized locally you can end up committing development files to the repo. To alert you, a CI action can be set up to check the static files.

Create a file `.github/workflows/static.yml` with the following content:

```bash
touch .github/workflows/test-static.yml
```

```yaml
name: check static assets

on:
  push:
    branches:
      - '!main'
      
  pull_request:
    branches:
      - main

jobs:
  static-assets:
    name: Static Assets
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Set up Node.js
        uses: actions/setup-node@v3
        with:
          node-version: 18

      - name: Set checks as executable
        run: chmod +x ./checks/*.sh

      - name: Install dependencies
        id: install-dependencies
        run: |
          npm ci

      - name: Check static
        run: ./checks/static.sh
```

This will run each time you push to a branch other than `main` and on every pull request to `main`. Depending on your account set up you should receive an email if the CI action fails.

Up Next - [Some TODO's](./z-todos.md)
