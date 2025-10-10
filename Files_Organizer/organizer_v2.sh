#!/bin/bash

filesPath="$1"
currentPath=$(pwd)

echo "Write the extensions to organize (separated by ",")"
echo "Example: .txt,.mp4,.mp3"
read -p "> " input

IFS=',' read -ra extensions <<< "$input"

echo ""
echo "Organizando archivos..."
echo ""

echo "${extensions[0]}"