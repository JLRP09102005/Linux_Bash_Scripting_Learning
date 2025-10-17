#!/bin/bash

if [ "$1" == "help" ]
then
    echo ""
    echo "Script Usage:"
    echo ""
    echo "At time select use '*' to select all options, use '/' to set an interval"
    echo "of time (*/5), use ',' to set multiple values, use '-' to set a range (1-5)."
    echo "Use the same time system as cron shell command."
    echo ""
    echo "Arguments:"
    echo "  Arg 1: minutes (0-59)"
    echo "  Arg 2: hours (0-23)"
    echo "  Arg 3: month day (1-31)"
    echo "  Arg 4: month (1-12)"
    echo "  Arg 5: day of week (0-7, where 0 and 7 are Sunday)"
    echo ""
    echo "Example: ./script.sh 30 2 * * * "
    echo ""
else
    if [ $# -lt 5 ]
    then
        echo "The script needs at least 5 arguments to work"
        echo "Usage: $0 'minutes' 'hours' 'day' 'month' 'weekday'"
    else
        minutes="$1"
        hours="$2"
        monthDays="$3"
        months="$4"
        weekDays="$5"
        scriptPath="/home/jozelu/Desktop/GitHub/Linux_Bash_Scripting_Learning/Backup_Creator/backup-cron-task.sh"

        echo "Write the directories path to back up"
        echo "**Example: Desktop/Github,home/bin"
        read -p ">  " directories

        directories=$("$directories" | tr -d ' ')
        crontabString="$minutes $hours $monthDays $months $weekDays bash $scriptPath \"$directories\""
        (sudo crontab -l 2>/dev/null; echo "$crontabString") | sudo crontab -
    fi
fi