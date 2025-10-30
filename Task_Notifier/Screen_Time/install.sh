#!/bin/bash

######################################
# VARIABLES
######################################

scriptPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" ## Optiene el path en el cual se encuentra el script principal ejecutado
userPath=""
serviceFinalPath=""
timerFinalPath=""
serviceOrigin="$scriptPath/config/screen_time_script.service"
timerOrigin="$scriptPath/config/screen_time_script.timer"
defaultInstallPath_user="/home/$(whoami)/.config/systemd/user/"
defaultInstallPath_system="/etc/systemd/system/"
isRootUser=false

######################################
# FUNCTIONS
######################################

ErrorExit()
{
    echo "ERROR: $1" >&2
    exit "${2:-1}"
}

# arg1(executed by root or user)
ModifyServiceArchives()
{
    if [ "$isRootUser" == "true" ]
    then
        echo "Modificar archivos para que sean de root"
    else
        echo "Modificar archivos para que sean de usuario"
    fi
}

CopyServiceArchives()
{
    if [ "$installLocation" == "1" -a "$isRootUser" == "false" ]
    then
        ErrorExit "Can't create the service in a system folder without root privilegies"
    fi

    instalationPath="$(GetInstalationPath "$installLocation")"

    cp -i "$serviceOrigin" "$instalationPath"
    serviceFinalPath="$instalationPath/$(basename "$serviceOrigin")"

    cp -i "$timerOrigin" "$instalationPath"
    timerFinalPath="$instalationPath/$(basename "$timerOrigin")"
}

# arg1(install location 1-system 2-user)
GetInstalationPath()
{
    if [ "$userPath" == "" ]
    then
        if [ "$1" -eq 1 ]
        then
            makdir -p "$defaultInstallPath_system"
            echo "$defaultInstallPath_system"
        else
            mkdir -p "$defaultInstallPath_user"
            echo "$defaultInstallPath_user"
        fi
    else
        echo "$userPath"
    fi
}

######################################
# MAIN SCRIPT
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