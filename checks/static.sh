#!/bin/bash

# This script generates production-ready files for the scripts and styles
# It runs npm run build
# If files are changed then fails

# Exit on error
set -e

# Run npm run build
npm run build
