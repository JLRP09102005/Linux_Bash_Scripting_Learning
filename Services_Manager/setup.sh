#!/bin/bash

#===== FUNCTIONS =====
ask_user_config_data()
{
    #Ask for a username
    read -e -i "default" -p "Write user name for data base (Enter for default): " USER_USERNAME

    #Ask for an email
    read -e -i "default@example.com" -p "Write an email for data base (Enter for default): " USER_EMAIL

    #Ask for full name
    read -e -i "Lorem Ipsum Dolor" -p "Write full name for data base (Enter for default): " USER_FULLNAME
}

update_config_values()
{
    local config_file="$CONFIG_DIRECTORY/config.sh"

    #Changes USER_USERNAME on config file or creates it if not exists
    if grep -q "^USER_USERNAME=" "$config_file"; then
        echo "Encontrada por grep"
        sed -i "s/^USER_USERNAME=.*/USER_USERNAME=\"${USER_USERNAME}\"/" "$config_file"
    else
        echo "USER_USERNAME=\"${USER_USERNAME}\"" >> "$config_file"
    fi

    #Changes USER_EMAIL on config file or creates it if not exists
    if grep -q "^USER_EMAIL=" "$config_file"; then
        echo "Encontrada por grep"
        sed -i "s/^USER_EMAIL=.*/USER_EMAIL=\"${USER_EMAIL}\"/" "$config_file"
    else
        echo "USER_EMAIL=\"${USER_EMAIL}\"" >> "$config_file"
    fi

    #Changes USER_EMAIL on config file or creates it if not exists
    if grep -q "^USER_FULLNAME=" "$config_file"; then
        echo "Encontrada por grep"
        sed -i "s/^USER_FULLNAME=.*/USER_FULLNAME=\"${USER_FULLNAME}\"/" "$config_file"
    else
        echo "USER_FULLNAME=\"${USER_FULLNAME}\"" >> "$config_file"
    fi
}

#===== SETUP MAIN =====
start_setup()
{
    print_header
    
    echo ""

    ask_user_config_data
    update_config_values

    #Create database credentials
    db_create_credentials

    #Create database and tables
    db_creation
}