#!/bin/bash

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
checker_boolean=""

######################################
## FUNCTIONS
######################################
ErrorExit()
{
    echo "error"
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

##############################################
## MAIN SCRIPT
##############################################
CheckRootPrivilegies

echo "Select service type to create (write the option number)"
echo "  1.-Notification by timer"
read -pr "> " serviceOption

checker_boolean="$(CheckOnlyNumbers "$serviceOption")"
if [ "$checker_boolean" == "false" ]; then
    ErrorExit
fi