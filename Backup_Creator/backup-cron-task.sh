#!/bin/bash
backupsPath="/home/$(whoami)/Backups"

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
            nombreArchivo="$(basename $directory)_$(date +%Y-%m-%d_%H-%M-%S)"
            newFilePath="$backupsPath/$nombreArchivo"
            directory="${directory%/}"

            cp -r "$directory" "$newFilePath"
            echo "Backup of $directory saved to $newFilePath"
        else
            echo "backup-cron-task couldn't find backup directory"
        fi
    done
fi