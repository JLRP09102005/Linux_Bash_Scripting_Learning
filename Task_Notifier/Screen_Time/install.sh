#!/bin/bash

## FUNCTIONS
ErrorExit()
{
    echo "ERROR: $1" >&2
    exit ${2:-1}
}

ModifyServiceArchives()
{
    if [ "$installLocation" == "1" -a "$isRootUser" == "true" ]
    then
        echo "copiar en sistema"
    elif [ "$installLocation" == "2" ]
    then
        echo "instalar usuario"
    else
        ErrorExit "Can't create the service in a system folder without root privilegies"
    fi
}

CopyServiceArchives()
{
    echo "copiar los archivos en el paz"
}

## CODE
isRootUser=false
if [ "$(whoami)" == "root" ]
then
    isRootUser=true
fi
# if [ "$EUID" -eq 0 ]; then
#     isRootUser=true
# fi

echo "Install in 1.-System or 2.-User"
read -p "> " installLocation
if [ "$installLocation" != "1" -a "$installLocation" != "2" ]
then
    ErrorExit "Type no valid at Install Location"
fi

echo "Set time in minutes"
read -p "> " serviceTime
if [[ ! "$serviceTime" =~ ^[0-9]+$ ]]
then
    ErrorExit "The time set was not in the correct type"
fi

echo "Install default location?(y/n)"
read -p "> " installDefaultAnswer
if [ "$installDefaultAnswer" == "no" -o "$installDefaultAnswer" == "n" ]
then
    echo "Write path instalation"
    read -p "> " userPath
    #Comprobar si es un path o el path existe
fi

ModifyServiceArchives