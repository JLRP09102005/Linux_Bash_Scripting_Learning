#!/bin/bash

#===== VERIFICATION/CONNECTION =====
mysql_check()
{
    if command -v mysql >/dev/null 2>&1; then
        print_error "MySQL is not installed"
        return 1
    fi

    if sudo systemctl is-active --quiet mysql; then
        print_error "MySQL service is not active"
        return 1
    fi

    if ! mysql -u "$DB_USER" -p "$DB_PASSWD" -e "SELECT 1" >/dev/null 2>&1; then
        print_error "Can't connect to MySQL"
        print_warning "Check MySQL credentials in config/config.sh"

        return 1
    fi
}

#===== DATABASE INITIALIZATION =====
db_init()
{
    echo "init db"
}