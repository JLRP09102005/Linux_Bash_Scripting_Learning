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

##############################################
## MAIN SCRIPT
##############################################
CheckRootPrivilegies

$dialog_separator
echo "Select service type to create (write the option number)"
echo "  1.-Notification by timer"
read -p "> " serviceOption
$dialog_separator

if [ "$(CheckOnlyNumbers "$serviceOption")" == "false" ]; then
    ErrorExit "Input contains no number characters"
fi

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
        echo "algo"
    else
        ErrorExit "Option selected no valid"
    fi

else
    ErrorExit "Option selected no valid"
fi