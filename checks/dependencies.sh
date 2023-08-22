#!/bin/bash

# Get the contents of requirements.txt
requirements=$(cat requirements.txt)

# Get the output from pipenv requirements
pipenv_requirements=$(pipenv requirements)

# Compare the two outputs
if [ "$requirements" == "$pipenv_requirements" ]; then
  echo "Requirements are correct"
else
  echo "Requirements are different, please run pipenv requirements > requirements.txt and stage the changes"
  exit 1
fi
