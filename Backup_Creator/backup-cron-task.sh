#!/bin/bash
backupsPath="~/Backups"

if [ $# -lt 1 ]
then
    echo "Backup cron task need at least 1 argument"
else
    directories="$1"
    IFS=',' read -ra directoriesPath <<< "$directories"

    for directory in "${directoriesPath[@]}"
    do
        mkdir -p "$backupsPath"

        if [ -e "$directory" ]
        then
            cp -r "$directory" "$backupsPath"
        else
            echo "backup-cron-task couldn't find backup directory"
        fi
    done
fi