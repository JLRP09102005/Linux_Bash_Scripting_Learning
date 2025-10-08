#!/bin/bash

filesPath="$1"
currentPath=$(pwd)

echo "Write the extensions to organize (separated by ",")"
echo "Example: .txt,.mp4,.mp3"
read -ra extensions

IFS=',' read -ra extensions