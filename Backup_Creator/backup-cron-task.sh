#!/bin/bash

if [ $# -lt 1 ]
then
    echo "Backup cron task need at least 1 argument"
else
    directoryPath="$1"
    mkdir -p "$directoryPath"
fi