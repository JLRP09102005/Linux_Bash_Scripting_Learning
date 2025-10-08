#!/bin/bash

#GET NECESSARY DIRECTORIES
filesPath = "$1"
currentPath = $(pwd)

#CREATE ORGANIZER FOLDERS PATH
textDirectory = "$currentPath/TextFiles"
imagesDirectory = "$currentPath/ImageDirectory"
videosDirectory = "$currentPath/VideoDirectory"

#CREATE ORGANIZER FOLDERS
mkdir -p "$textDirectory"
mkdir -p "$imagesDirectory"
mkdir -p "$videosDirectory"

#MOVE ARCHIVES
mv "$filesPath"/*.txt "$textDirectory"

mv "filesPath"/*.png "imagesDirectory"
mv "filesPath"/*.jpg "imagesDirectory"

mv "filesPath"/*.mp4 "videosDirectory"
mv "filesPath"/*.mkv "videosDirectory"