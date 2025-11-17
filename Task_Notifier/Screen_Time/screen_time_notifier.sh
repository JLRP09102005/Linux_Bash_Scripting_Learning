#!/bin/bash

#################################
## VARIABLES
#################################
option1="restart"
option2="modify"
option3="disable"
isRootUser="false"

servicePath=""
timerPath=""

###############################
## FUNCTIONS
###############################
GetServicePaths()
{
    if [ "$isRootUser" == "root" ]; then
        servicePath=$(systemctl cat screen_time_script.service | sed -n '1p' | sed 's|#||g' | tr -d ' ') # METHOD-1
        # timerPath=$(realpath screen_time_script.timer) #METHOD-2 (but this method return the .timer from the config file)
        timerPath=$(systemctl cat screen_time_script.timer | sed -n '1p' | sed 's|#||g' | tr -d ' ')
    else
        servicePath=$(systemctl --user cat screen_time_script.service | sed -n '1p' | sed 's|#||g' | tr -d ' ') # METHOD-1
        # timerPath=$(realpath screen_time_script.timer) #METHOD-2 (but this method return the .timer from the config file)
        timerPath=$(systemctl --user cat screen_time_script.timer | sed -n '1p' | sed 's|#||g' | tr -d ' ')
    fi
}

ModifyTimer()
{
    read -p "New Timer time in min > " newTimer
    sed -i "s|OnUnitActiveSec=.*|OnUnitActiveSec=${newTimer}min|" "$timerPath"

    RestartTimer
}

RestartTimer()
{
    if [ "$isRootUser" == "true" ]; then
        sudo systemctl daemon-reload
        sudo systemctl restart screen_time_script.timer
    else
        systemctl --user daemon-reload
        systemctl --user restart screen_time_script.timer
    fi
}

DisableTimer()
{
    if [ "$isRootUser" == "root" ]; then
        sudo systemctl stop "$(basename "$timerPath")"
        sudo systemctl stop "$(basename "$servicePath")"
    else
        systemctl --user stop "$(basename "$timerPath")"
        systemctl --user stop "$(basename "$servicePath")"
    fi
}

###################################
## MAIN SCRIPT
###################################
GetServicePaths

if [ "$1" == "--modify" ]; then
    ModifyTimer
fi

if [ "$(whoami)" == "root" ]; then
    isRootUser="true"
fi

answer=$(notify-send -w \
-a 'Screen Time Notifier' \
'Time To Rest' \
'Remember to rest your eyes from the screen' \
-A "$option1=Restart Timer" \
-A "$option2=Modify Timer" \
-A "$option3=Disable Timer" \
-A "dismissTimer=Dismiss" \
-u "critical")

if [ "$answer" == "$option1" ]; then
    RestartTimer
elif [ "$answer" == "$option2" ]; then
    if [ "$isRootUser" == "true" ]; then
        sudo x-terminal-emulator -e bash -c "$0 --modify"
    else
        x-terminal-emulator -e bash -c "$0 --modify"
    fi
elif [ "$answer" == "$option3" ]; then
    GetServicePaths
    DisableTimer
fi