#!/bin/bash

if [ "$1" == "help" ]
then
    echo ""

    echo ">SINTAXI: organizer_v2 [files path]"

    echo ""

    echo ">ABOUT: this script organizes the files from a general directory on separated directories my the extensions indicated"
else
    filesPath="$1"
    currentPath=$(pwd)

    echo "Write the extensions to organize (separated by ",")"
    echo "Example: .txt,.mp4,.mp3"
    read -p "> " input

    IFS=',' read -ra extensions <<< "$input"

    echo ""
    echo "Organizando archivos..."
    echo ""

    for ext in "${extensions[@]}"
    do
        ext=$(echo "$ext" | tr -d ' ' | tr -d '.')

        extDirectory="$currentPath/${ext}_files"
        mkdir -p "$extDirectory"

        if ls "$filesPath"/*."${ext}" 1> /dev/null 2> /dev/null
        then
            mv "$filesPath"/*."${ext}" "$extDirectory"
        fi
    done
fi