#!/bin/bash

######################################
# VARIABLES
######################################

isRootUser=false
userPath=""
serviceCopiedPath=""
timerCopiedPath=""

######################################
## FUNCTIONS
######################################

ErrorExit()
{
    echo "ERROR: $1" >&2
    exit ${2:-1}
}

# arg1(executed by root or user)
ModifyServiceArchives()
{
    if [ "$1" -eq 1 ]
    then
        echo "Modificar archivos para que sean de root"
    else
        echo "Modificar archivos para que sean de usuario"
    fi
}

CopyServiceArchives()
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

# arg1(install location)
GetInstalationPath()
{


    if [ "$userPath" == "" ]
    then
        if [ "$1" -eq 1 ]
        then
            echo "instalacion en sistema"
        else
            echo "instalacion en usuario"
        fi
    else
        return "$userPath"
    fi
}

######################################
## MAIN SCRIPT
######################################

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

CopyServiceArchives