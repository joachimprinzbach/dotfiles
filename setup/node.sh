#!/usr/bin/env bash

# Setup Node and install global packages
# Requires: n
debug=${1:-false}

# Load help lib if not already loaded.
if [ -z ${libloaded+x} ]; then
  source ./lib.sh
fi;

# Check if n is installed.
if hash n 2>/dev/null; then
  botintro "Installing latest and LTS versions of Node."

  # Create dirs and set current user as owner (prevent sudo issues)
  action "Creating Node directories"

  sudo mkdir "/usr/local/n"
  sudo chown -R $(whoami) "/usr/local/n"

  sudo mkdir "/usr/local/lib/node_modules"
  sudo chown -R $(whoami) "/usr/local/lib/node_modules"

  # Install latest distro.
  action "Installing latest Node distro"

  n latest;

  # Install LTS distro.
  action "Installing Node LTS distro"

  n lts;

  # Update npm for LTS.
  action "Updating npm."

  npm install npm -g;

  # Install global Node packages.
  action "Installing Node global packages."

  packages=(
    create-react-app
    @angular/cli
    prettier
    @vue/cli
  )

  for package in ${packages[@]}; do
    npm install --global $package
  done

  # fin.
else
  echo "WARNING: n not found.";
fi;
