#!/bin/bash

####################################
## IDEAS
####################################
#1.-Para montar los archivos hacer alguna funcion estilo for que pase por todo lo que tiene que escribir y la llamada sea algo como (funcion "$unit_section" "enter" "$description{$inputUsuario}" ")

#################################################
## MODULAR BLOCKS
#################################################
unit_section="[Unit]"
service_section="[Service]"
timer_section="[Timer]"
install_section="[Install]"

description="Description="
type="Type="
exec_start="ExecStart="
restart="Restart="
on_boot_sec="OnBootSec="
on_unit_active_sec="OnUnitActiveSec="
wanted_by="WantedBy="

########################################
## VARIABLES
########################################
isRootUser="false"
dialog_separator="echo """
build_archive_result=""

services_installation_path=("/etc/systemd/system" "/home/$(whoami)/.config/systemd/user")
scripts_installation_path=("/usr/local/bin" "home/$(whoami)/.local/bin")
user_services_installation_path=""
user_scripts_installation_path=""

###############################################
## SCRIPT NAMES
###############################################
screen_time_notifier_timer_scriptname="screen_time_notifier_timer.sh"

######################################
## FUNCTIONS
######################################
ErrorExit()
{
    echo "ERROR: $1" >&2
    exit "${2:-1}"
}

CheckRootPrivilegies()
{
    if [ "$(whoami)" == "root" ]; then
        isRootUser="true"
    else
        isRootUser="false"
    fi
}

CheckOnlyNumbers()
{
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        echo "true"
    else
        echo "false"
    fi
}

ServiceFilesCreator()
{
    echo "menudo vago soy"
}

ScreenNotificationTimerBuildService()
{
    local unit_description
    local service_type
    local service_exec_start
    local service_restart
    local service_wanted_by

    if [ "$isRootUser" == "true" ]; then
        service_exec_start="${scripts_installation_path[0]}/$screen_time_notifier_timer_scriptname"
        service_wanted_by="multi-user.target"
    else
        service_exec_start="${scripts_installation_path[1]}/$screen_time_notifier_timer_scriptname"
        service_wanted_by="default.target"
    fi

    $dialog_separator
    read -e -i "Screen Time Notifier Service" -p "Service Description: " unit_description
    read -e -i "simple" -p "Type: " service_type
    echo "ExecStart: $service_exec_start"
    read -e -i "on-failure" -p "Restart: " service_restart
    echo "WantedBy: $service_wanted_by"
    $dialog_separator

}

ScreenNotificationTimerBuildTimer()
{
    local unit_description
    local timer_on_boot_sec
    local timer_on_unit_active_sec
    local install_wanted_by

    if [ "$isRootUser" == true ]; then
        install_wanted_by="multi-user.target"
    else
        install_wanted_by="default.target"
    fi

    $dialog_separator
    read -e -i "Screen Time Notifier Timer" -p "Description: " unit_description
    read -e -i "1min" -p "OnBootSec: " timer_on_boot_sec
    read -e -i "20min" -p "OnUnitActiveSec: " timer_on_unit_active_sec
    echo "WantedBy: $install_wanted_by"

}

##############################################
## MAIN SCRIPT
##############################################
CheckRootPrivilegies

## Select service type
$dialog_separator
echo "Select service type to create (write the option number)"
echo "  1.-Notification by timer"
read -p "> " serviceOption
$dialog_separator

if [ "$(CheckOnlyNumbers "$serviceOption")" == "false" ]; then
    ErrorExit "Input contains no number characters"
fi

$dialog_separator
read -p "Install on default path?(y/n)> " isUsingDefaultPath
$dialog_separator

if [[ "$isUsingDefaultPath" == "n" || "$isUsingDefaultPath" == "no" ]]; then
    echo "pedir el nuevo path de cada cosa"
elif [[ "$isUsingDefaultPath" != "y" && "$isUsingDefaultPath" != "yes" ]]; then
    ErrorExit "Input dont match with the correct format"
fi

## Select notification by timer option
if [ "$serviceOption" -eq 1 ]; then

    $dialog_separator
    echo "Select notification type"
    echo "  1.-Screen use notification"
    read -p "> " notificationOption
    $dialog_separator

    if [ "$(CheckOnlyNumbers "$notificationOption")" == "false" ]; then
        ErrorExit "Input contains no number characters"
    fi

    if [ "$notificationOption" -eq 1 ]; then

        echo "Creating the service that executes the notification script..."
        ScreenNotificationTimerBuildService
    
    else
        ErrorExit "Option selected no valid"
    fi

else
    ErrorExit "Option selected no valid"
fi