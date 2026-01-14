#!/bin/bash

#===== System Info =====
SYSTEM_NAME="Service Manager System"
SYSTEM_VERSION="1.0.0"
SYSTEM_AUTHOR="jjolisrp"

#===== Directories =====
BASE_DIRECTORY="$SCRIPT_DIR"
LIB_DIRECTORY="$BASE_DIRECTORY/lib"
MODULES_DIRECTORY="$BASE_DIRECTORY/modules"
CONFIG_DIRECTORY="$BASE_DIRECTORY/config"
LOGS_DIRECTORY="$BASE_DIRECTORY/logs"
BACKUPS_DIRECTORY="$BASE_DIRECTORY/backups"

#===== MYSQL CONFIGURATION =====
DB_HOST="localhost"
DB_USER="serviceuser"
DB_USER_EMAIL="serviceuser@example.com"
DB_USER_FULLNAME="Lorem Ipsum Dolor"
DB_PASSWD="serviceuser123"
DB_PORT="3306"
DB_NAME="services_db"

#===== User Data =====
USER_USERNAME="default"
USER_EMAIL="default@example.com"
USER_FULLNAME="Lorem Ipsum Dolor"