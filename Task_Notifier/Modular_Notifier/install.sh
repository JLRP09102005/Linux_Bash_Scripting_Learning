#!/bin/bash

####################################
## IDEAS
####################################
#1.-Para montar los archivos hacer alguna funcion estilo for que pase por todo lo que tiene que escribir y la llamada sea algo como (funcion "$unit_section" "enter" "$description{$inputUsuario}" ")
#2.-Al activar los servicios, preguntar al usuario si los quiere enable, para iniciar al arranque (incluso si les quiere hacer start ahora)

#################################################
## MODULAR BLOCKS
#################################################
separation=""
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

<<<<<<< Updated upstream
<<<<<<< Updated upstream
# service_scripts_path="$(pwd)/services_scripts"
=======
scripts_library_path="$(pwd)/services_scripts"
>>>>>>> Stashed changes
=======
scripts_library_path="$(pwd)/services_scripts"
>>>>>>> Stashed changes
services_installation_path=("/etc/systemd/system" "/home/$(whoami)/.config/systemd/user")
scripts_installation_path=("/usr/local/bin" "/home/$(whoami)/.local/bin")
user_services_installation_path=""
user_scripts_installation_path=""

###############################################
## SCRIPT/SERVICE NAMES
###############################################
screen_time_notifier_timer_scriptname="screen_time_notifier_timer.sh"

screen_time_timer_servicename="screen_time_timer.service"
screen_time_timer_timername="screen_time_timer.timer"
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

##Arg1 -> nombre archivo / Arg2 -> array con contenido archivo
ServiceFilesCreator()
{
    local filename="$1"
    local output_path
    shift

    if [ "$isRootUser" == "true" ]; then
        output_path="${services_installation_path[0]}/$filename"
        printf "%s\n" "$@" | sudo tee "$output_path"
    else
        output_path="${services_installation_path[1]}/$filename"
        printf "%s\n" "$@" > "$output_path"
    fi

    echo "Created File: $output_path"
}

ServiceActivator()
{
    echo "Activar servicios"
}

## Arg1 -> script names to copy
CopyServiceScripts()
{
<<<<<<< Updated upstream
<<<<<<< Updated upstream
    local service_scripts_dest

    if [ "$isRootUser" == "true" ]; then
        service_scripts_dest="${scripts_installation_path[1]}"
    else
        service_scripts_dest="${scripts_installation_path[0]}"
=======
=======
>>>>>>> Stashed changes
    local scripts_dest

    if [ "$isRootUser" == "true" ]; then
        scripts_dest="${scripts_installation_path[0]}"
    else
        scripts_dest="${scripts_installation_path[1]}"
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
    fi

    for script in "$@"
    do
<<<<<<< Updated upstream
<<<<<<< Updated upstream
        echo "search script name, look if exists, and copy them $script"
        cp "$(realpath "$script")" "$service_scripts_dest"
=======
        cp "$scripts_library_path/$script" "$scripts_dest"
>>>>>>> Stashed changes
=======
        cp "$scripts_library_path/$script" "$scripts_dest"
>>>>>>> Stashed changes
    done
}

## Arg1 -> service names
ActiveServices()
{
    if [ "$isRootUser" == "true" ]; then
        sudo systemctl daemon-reload
 
        for service in "$@"
        do
            sudo systemctl enable "$service"
            sudo systemctl start "$service"
        done
    else
        systemctl --user daemon-reload

        for service in "$@"
        do
            systemctl --user enable "$service"
            systemctl --user start "$service"
        done
    fi
}

ScreenNotificationTimerBuildService()
{
    local unit_description
    local service_type
    local service_exec_start
    local service_restart
    local install_wanted_by

    if [ "$isRootUser" == "true" ]; then
        service_exec_start="${scripts_installation_path[0]}/$screen_time_notifier_timer_scriptname"
        install_wanted_by="multi-user.target"
    else
        service_exec_start="${scripts_installation_path[1]}/$screen_time_notifier_timer_scriptname"
        install_wanted_by="default.target"
    fi

    $dialog_separator
    read -e -i "Screen Time Notifier Service" -p "Service Description: " unit_description
    read -e -i "simple" -p "Type: " service_type
    echo "ExecStart: $service_exec_start" >&2
    read -e -i "on-failure" -p "Restart: " service_restart
    echo "WantedBy: $install_wanted_by" >&2
    $dialog_separator

    local tmp_array=(
        "$unit_section"
        "${description}${unit_description}"
        "$separation"
        "$service_section"
        "${type}${service_type}"
        "${exec_start}${service_exec_start}"
        "${restart}${service_restart}"
        "$separation"
        "$install_section"
        "${wanted_by}${install_wanted_by}"
    )
    
    printf "%s\n" "${tmp_array[@]}"
}

ScreenNotificationTimerBuildTimer()
{
    local unit_description
    local timer_on_boot_sec
    local timer_on_unit_active_sec
    local install_wanted_by

    if [ "$isRootUser" == "true" ]; then
        install_wanted_by="multi-user.target"
    else
        install_wanted_by="default.target"
    fi

    $dialog_separator
    read -e -i "Screen Time Notifier Timer" -p "Description: " unit_description
    read -e -i "1min" -p "OnBootSec: " timer_on_boot_sec
    read -e -i "20min" -p "OnUnitActiveSec: " timer_on_unit_active_sec
    echo "WantedBy: $install_wanted_by" >&2
    $dialog_separator

    local tmp_array=(
        "$unit_section"
        "${description}${unit_description}"
        "$separation"
        "$timer_section"
        "${on_boot_sec}${timer_on_boot_sec}"
        "${on_unit_active_sec}${timer_on_unit_active_sec}"
        "$separation"
        "$install_section"
        "${wanted_by}${install_wanted_by}"
    )

    printf "%s\n" "${tmp_array[@]}"
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
        readarray -t service_content < <(ScreenNotificationTimerBuildService)
        ServiceFilesCreator "$screen_time_timer_servicename" "${service_content[@]}"
        
        $dialog_separator

        echo "Creating the timer that executes the service..."
        readarray -t service_content < <(ScreenNotificationTimerBuildTimer)
        ServiceFilesCreator "$screen_time_timer_timername" "${service_content[@]}"

        $dialog_separator

        echo "Moving necessary scripts for services"
        CopyServiceScripts "$screen_time_notifier_timer_scriptname"

        $dialog_separator

        echo "Activating services"
        ActiveServices "$screen_time_timer_servicename" "$screen_time_timer_timername"
    
    else
        ErrorExit "Option selected no valid"
    fi

else
    ErrorExit "Option selected no valid"
fi