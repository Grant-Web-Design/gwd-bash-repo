#!/bin/bash

echo "Grant Web Design install-server script"
echo "Checking if we're running with sudo rights"

timeout -s SIGKILL 5s sudo -v && (echo "Sudo rights enabled" ; exit 0) || (echo "No sudo rights, please run this script with sudo" ; exit 1)

echo ""
echo "Updating apt-get repository..."
sudo apt-get update -y -qq

echo "Installing git..."
sudo apt-get install git -qq -y

echo "Installing Node 14 repository..."
sudo curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -

echo "Installing Node.js and NPM..."
sudo apt-get install nodejs npm -qq -y

echo "Verifying Node.js and NPM versions"


function version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }

MIN_NODE_VERSION=14.0.0
MAX_NODE_VERSION=15.0.0
MIN_NPM_VERSION=6.0.0

INSTALLED_NODE_VERSION="$(node --version | head -1)"
INSTALLED_NPM_VERSION="$(npm --version | head -1)"

echo "Installed node version: ${INSTALLED_NODE_VERSION}"
echo "Installed npm version: ${INSTALLED_NPM_VERSION}"

if version_gt $INSTALLED_NODE_VERSION $MIN_NODE_VERSION;
then
  echo "Node satisfies minimum required version"
else
  echo "Incorrect version of node installed, lowest allowed version is ${MIN_NODE_VERSION}"
  exit 1
fi

if version_gt $INSTALLED_NODE_VERSION $MAX_NODE_VERSION;
then
  echo "Incorrect version of node installed, highest allowed version is ${MAX_NODE_VERSION}"
  exit 1
else
  echo "Node satisfies maximum required version"
fi

if version_gt $INSTALLED_NPM_VERSION $MIN_NPM_VERSION;
then
  echo "Npm satisfies minimum required version"
else
  echo "Incorrect version of npm installed, lowest allowed version is ${MIN_NPM_VERSION}"
  exit 1
fi

echo "Verified node and npm versions"

echo "Installing git..."
sudo apt-get install git -qq -y

echo "Required applications installed successfully"

echo "Adding private Grant Web Design npm package registry"
read -p "Please enter a GitHub access token that has access to the registry: " GITHUB_ACCESS_TOKEN

sudo touch ~/.npmrc
printf "//npm.pkg.github.com/:_authToken=${GITHUB_ACCESS_TOKEN}" > ~/.npmrc

echo "Installing gwd-server-installer package..."
sudo npm i -g @grant-web-design/gwd-server-installer@latest

echo "Starting the installer..."
sudo setup-server