#!/bin/bash

######################################
# VARIABLES
######################################

scriptPath="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" ## Optiene el path en el cual se encuentra el script principal ejecutado
mainScriptPath="$(realpath screen_time_notifier.sh)"

userPath=""
serviceFinalPath=""
timerFinalPath=""
scriptFinalPath=""

serviceOrigin="$scriptPath/config/screen_time_script.service"
timerOrigin="$scriptPath/config/screen_time_script.timer"

defaultInstallPath_user="/home/$(whoami)/.config/systemd/user"
defaultInstallPath_system="/etc/systemd/system"
defaultInstallPath_script="/usr/local/bin"

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
    sed -i "s|timeperexecute|$serviceTime|g" "$timerFinalPath"
    sed -i "s|execstart|$scriptFinalPath|g" "$serviceFinalPath"

    if [ "$isRootUser" == "true" ]
    then
        sed -i 's|wantedby|multi-user.target|g' "$serviceFinalPath" "$timerFinalPath"
    else
        sed -i 's|wantedby|default.target|g' "$serviceFinalPath" "$timerFinalPath"
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

    cp -i "$mainScriptPath" "defaultInstallPath_script"
    scriptFinalPath="$defaultInstallPath_script/$(basename "$mainScriptPath")"
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

StartServices()
{
    if [ "$isRootUser" == "true" ]; then
        sudo systemctl start "$(basename "$timerFinalPath")"
        sudo systemctl start "$(basename "$serviceFinalPath")"
    else
        systemctl --user start "$(basename "$timerFinalPath")"
        systemctl --user start "$(basename "$serviceFinalPath")"
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

echo "Set time in minutes (Ex. 10)"
read -p "> " serviceTime
if [[ ! "$serviceTime" =~ ^[0-9]+$ ]]
then
    ErrorExit "The time set was not in the correct type"
fi
# Agregar la extension de min al numero elegido por el usuario
serviceTime=$(echo "$serviceTime" | xargs)
serviceTime+="min"

echo "Install default location?(y/n)"
read -p "> " installDefaultAnswer
if [ "$installDefaultAnswer" == "no" -o "$installDefaultAnswer" == "n" ]
then
    echo "Write path instalation"
    read -p "> " userPath
fi

CopyServiceArchives
ModifyServiceArchives
StartServices