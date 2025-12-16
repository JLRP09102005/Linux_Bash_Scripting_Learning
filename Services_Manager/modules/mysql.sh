#!/bin/bash

mysql_menu()
{
    local option=-1

    while [ "$option" -ne 0 ]; do
        
        clear

        print_header
        cat << "EOF"
===============MYSQL MANAGER===============
        
        [1] Data Base Management
        [2] User Management
        [3] Tables Management
        [4] Backup And Restauration
        [5] Queries And Analysis
        [6] Server Administration
        [7] Monitoring And Stadistics
        [8] Security
        [9] Maintenance
        [10] Check Services

        [0] Exit

EOF
        print_divider

        read -p "Choose One Option: " option

        if [ "$option" == 1 ]; then
            echo "Data base management menu"
        elif [ "$option" == 2 ]; then
            echo "User management menu"
        elif [ "$option" == 3 ]; then
            echo "tables management"
        elif [ "$option" == 4 ]; then
            echo "Backup and restauration"
        elif [ "$option" == 5 ]; then
            echo "Queries and analysis"
        elif [ "$option" == 6 ]; then
            echo "Server administration"
        elif [ "$option" == 7 ]; then
            echo "Monitoring and stadistics"
        elif [ "$option" == 8 ]; then
            echo "Security"
        elif [ "$option" == 9 ]; then
            echo "Maintenance"
        elif [ "$option" == 10 ]; then
            echo "Check services"
        elif [ "$option" == 0 ]; then
            print_info "Exiting Mysql Manager..."
            wait_time 1
        else
            print_warning "Make sure to choose a correct option"
            press_enter_continue
        fi

    done
}