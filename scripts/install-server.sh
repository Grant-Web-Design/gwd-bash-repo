#!/bin/bash

read -p "Hoe gaat het" HOE_GAAT_HET
echo "Antwoord: ${HOE_GAAT_HET}"

echo "Grant Web Design install-server script"
echo "Checking if we're running with sudo rights"

timeout -s SIGKILL 5s sudo -v && (echo "Sudo rights enabled" ; exit 0) || (echo "No sudo rights, please run this script with sudo" ; exit 1)

echo ""
echo "Updating apt-get repository..."
sudo apt-get update -y -qq

echo "Installing git..."
sudo apt-get install git -qq -y

echo "Installing Node 14 repository..."
cd ~
curl -sL https://deb.nodesource.com/setup_14.x -o setup_14.sh
sudo sh ./setup_14.sh

echo "Installing Node.js and NPM..."
sudo apt-get install -y nodejs

INSTALLED_NODE_VERSION="$(node --version | head -1)"
INSTALLED_NPM_VERSION="$(npm --version | head)"
echo "Installed node version: ${INSTALLED_NODE_VERSION}"
echo "Installed npm version: ${INSTALLED_NPM_VERSION}"

echo "Installing git..."
sudo apt-get install git -qq -y

echo "Required applications installed successfully"

echo "Adding private Grant Web Design npm package registry"

read -p "Please enter a GitHub access token that has access to the registry: " GITHUB_ACCESS_TOKEN

sudo echo "@grant-web-design:registry=https://npm.pkg.github.com
//npm.pkg.github.com/:_authToken=${GITHUB_ACCESS_TOKEN}" > ~/.npmrc

echo "Installing gwd-server-installer package..."
sudo npm i -g @grant-web-design/gwd-server-installer@latest

echo "Starting the installer..."
sudo setup-server