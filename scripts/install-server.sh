#!/bin/bash

echo "This is the Grant Web Design install server script"
ls

timeout 2 sudo id && sudo="true" || sudo="false"
echo "$sudo"

echo "Checking if we're running with sudo rights"

timeout -s SIGKILL 5s sudo -v && (echo "Sudo rights enabled" ; exit 0) || (echo "No sudo rights, please run this script with sudo" ; exit 1)