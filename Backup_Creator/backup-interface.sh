#!/bin/bash

if [ "$1" == "help" ]
then
    echo ""
    echo "Script Usage:"
    echo ""

    echo "**At time select use '*' to select all options, use '/' to set an interval of time (5/7), use ',' to set multiple values, use '-' to set a range of times (1-5). Use the same time sistem of cron shell command"
    echo ""

    echo "--Arg 1: minutes"
    echo "--Arg 2: hours"
    echo "--Arg 3: month day"
    echo "--Arg 4: month"
    echo "--Arg 5: day of week"
    echo ""
else
    if [ $# -lt 5 ]
    then
        echo "The script needs at least 5 arguments to work"
    else
        minutes=$1
        hours=$2
        monthDays=$3
        months=$4
        weekDays=$5

        echo "Write the directories path to back up"
        echo "**Example: Desktop/Github,home/bin"
        read -p ">  " directoriesPath
    fi
fi