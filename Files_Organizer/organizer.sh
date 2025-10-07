#!/bin/bash

filesPath = @1
currentPath = $(pwd)
textDirectory = "$currentPath/TextFiles"

mkdir -p "$textDirectory"

mv "$filesPath"/*.txt "$textDirectory"