#!/bin/bash

#GET NECESSARY DIRECTORIES
filesPath="$1"
currentPath=$(pwd)

#CREATE ORGANIZER FOLDERS PATH
textDirectory="$currentPath/TextFiles"
imagesDirectory="$currentPath/ImageDirectory"
videosDirectory="$currentPath/VideoDirectory"

#CREATE ORGANIZER FOLDERS
mkdir -p "$textDirectory"
mkdir -p "$imagesDirectory"
mkdir -p "$videosDirectory"

#MOVE ARCHIVES
mv "$filesPath"*.txt "$textDirectory" 2>/dev/null

mv "$filesPath"*.png "$imagesDirectory" 2>/dev/null
mv "$filesPath"*.jpg "$imagesDirectory" 2>/dev/null

mv "$filesPath"*.mp4 "$videosDirectory" 2>/dev/null
mv "$filesPath"*.mkv "$videosDirectory" 2>/dev/null