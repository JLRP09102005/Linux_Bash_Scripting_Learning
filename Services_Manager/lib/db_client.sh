#!/bin/bash

#===== GLOBAL VARIABLES =====
MYSQL_ROOT_PASSWORD=""

#===== VERIFICATION/CONNECTION =====
mysql_is_installed()
{
    command -v mysql >/dev/null 2>&1
}

mysql_service_is_running()
{
    systemctl is-active --quiet mysql
}

mysql_credentials_exists()
{
    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWD" -e "SELECT 1;" >/dev/null 2>&1
}

mysql_general_check()
{
    #Checks if mysql is installed
    if ! mysql_is_installed; then
        print_error "MySQL is not installed"
        return 1
    fi

    #Checks if mysql service is running
    if ! mysql_service_is_running; then
        print_error "MySQL service is not running"
        return 1
    fi

    #Checks mysql connection with credentials
    if ! mysql_credentials_exists; then
        print_error "Can't connect to MySQL"
        print_warning "Check MySQL credentials in config/config.sh"
        return 1
    fi
}

execute_query()
{
    local query="$1"

    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWD" -D "$DB_NAME" -e "$query" 2>>"$LOGS_DIRECTORY/db_client-mysql_errors.log"
}

#Arg1 -> query / Arg2 -> root password
execute_query_as_root()
{
    local query="$1"
    local root_pass="$2"

    mysql -u root -p"$root_pass" -e "$query" 2>>"$LOGS_DIRECTORY/db_client-mysql_errors.log"
}

#===== DATABASE CREATION =====
db_create_credentials()
{
    if ! mysql_is_installed || ! mysql_service_is_running; then
        return 1
    fi

    ask_mysql_root_passwd

    local query

    query="
    CREATE USER '$DB_USER'@'$DB_HOST' IDENTIFIED BY '$DB_PASSWD'"
    execute_query_as_root "$query" "$MYSQL_ROOT_PASSWORD"

    query="
    GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'$DB_HOST' WITH GRANT OPTION"
    execute_query_as_root "$query" "$MYSQL_ROOT_PASSWORD"

    query="
    FLUSH PRIVILEGES"
    execute_query_as_root "$query" "$MYSQL_ROOT_PASSWORD"
}

db_creation()
{
    if ! mysql_general_check; then
        return 1;
    fi

    ask_mysql_root_passwd

    local query

    query="
    DROP DATABASE IF EXISTS $DB_NAME"
    execute_query_as_root "$query" "$MYSQL_ROOT_PASSWORD"

    query="
    CREATE DATABASE $DB_NAME"
    execute_query_as_root "$query" "$MYSQL_ROOT_PASSWORD"

    #Create services table
    query="
    CREATE TABLE services (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(50) UNIQUE NOT NULL,
        status ENUM('running','stopped','error') DEFAULT 'stopped',
        host VARCHAR(100) DEFAULT 'localhost',
        description VARCHAR(100),
        image VARCHAR(200),
        config_path VARCHAR(200),
        type INT NOT NULL,
        user_id INT NOT NULL
    )"
    execute_query "$query"

    #Create services types table
    query="
    CREATE TABLE service_types (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(50) NOT NULL
    )"
    execute_query "$query"

    #Create logs table
    query="
    CREATE TABLE service_logs (
        id INT AUTO_INCREMENT PRIMARY KEY,
        action VARCHAR(50),
        details VARCHAR(200),
        ip_address VARCHAR(50),
        service_id INT,
        user_id INT
    )"
    execute_query "$query"

    #Create environment variables table
    query="
    CREATE TABLE service_env (
        id INT AUTO_INCREMENT PRIMARY KEY,
        key_name VARCHAR(100),
        value TEXT,
        service_id INT NOT NULL
    )"
    execute_query "$query"

    #Create users table
    query="
    CREATE TABLE users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(50) UNIQUE NOT NULL,
        full_name VARCHAR(100),
        email VARCHAR(100)
    )"
    execute_query "$query"

    #Create service ports table
    query="
    CREATE TABLE service_ports (
        id INT AUTO_INCREMENT PRIMARY KEY,
        host_port SMALLINT,
        container_port SMALLINT,
        protocol ENUM('tcp','udp') DEFAULT 'tcp'
    )"
    execute_query "$query"

    #Intermediate table services-service_pors
    query="
    CREATE TABLE ports_services (
        port_id INT NOT NULL,
        service_id INT NOT NULL
    )"
    execute_query "$query"

    #Services foreign key
    query="
    ALTER TABLE services
    ADD CONSTRAINT fk_users_services FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_service_types_services FOREIGN KEY (type) REFERENCES service_types(id)
        ON DELETE CASCADE"
    execute_query "$query"

    #Service logs foreign key
    query="
    ALTER TABLE service_logs
    ADD CONSTRAINT fk_service_service_logs FOREIGN KEY (service_id) REFERENCES services(id)
        ON DELETE SET NULL,
    ADD CONSTRAINT fk_user_service_logs FOREIGN KEY (user_id) REFERENCES users(id)
        ON DELETE SET NULL"
    execute_query "$query"

    #Service environment foreign key
    query="
    ALTER TABLE service_env
    ADD CONSTRAINT fk_services_service_env FOREIGN KEY (service_id) REFERENCES services(id)
        ON DELETE CASCADE"
    execute_query "$query"

    #Ports-services primary key + foreign keys
    query="
    ALTER TABLE ports_services
    ADD CONSTRAINT fk_service_ports_ports_services FOREIGN KEY (port_id) REFERENCES service_ports(id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_services_ports_services FOREIGN KEY (service_id) REFERENCES services(id)
        ON DELETE CASCADE,
    ADD PRIMARY KEY(port_id, service_id)"
    execute_query "$query"

    #Service audit columns
    query="
    ALTER TABLE services
    ADD created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ADD updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP"
    execute_query "$query"

    #Service logs created date column
    query="
    ALTER TABLE service_logs
    ADD created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP"
    execute_query "$query"
}

#===== DATABASE INITIALIZATION =====
#Resolve errors if exists
db_init()
{
    if ! mysql_general_check; then
        return 1
    fi

    ask_mysql_root_passwd

    local query

    query="
    CREATE USER IF NOT EXISTS '$DB_USER'@'$DB_HOST' IDENTIFIED BY '$DB_PASSWD'"
    execute_query_as_root "$query" "$MYSQL_ROOT_PASSWORD"

    query="
    GRANT ALL PRIVILEGES $DB_NAME.* TO '$DB_USER'@'$DB_HOST' WITH GRANT OPTION"

    query="
    CREATE DATABASE IF NOT EXISTS $DB_NAME"
    execute_query "$query"

    query="
    CREATE TABLE IF NOT EXISTS services (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(50) UNIQUE NOT NULL,
        status ENUM('running','stopped','error') DEFAULT 'stopped',
        host VARCHAR(100) DEFAULT 'localhost',
        description VARCHAR(100),
        image VARCHAR(200),
        config_path VARCHAR(200),
        type INT NOT NULL,
        user_id INT NOT NULL,
        created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT fk_users_services FOREIGN KEY (user_id) REFERENCES users(id)
            ON DELETE CASCADE,
        CONSTRAINT fk_service_types_services FOREIGN KEY (type) REFERENCES service_types(id)
            ON DELETE CASCADE
    )"
    execute_query "$query"

    query="
    CREATE TABLE IF NOT EXISTS service_types (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(50) NOT NULL
    )"
    execute_query "$query"

    query="
    CREATE TABLE service_logs (
        id INT AUTO_INCREMENT PRIMARY KEY,
        action VARCHAR(50),
        details VARCHAR(200),
        ip_address VARCHAR(50),
        service_id INT,
        user_id INT,
        created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT fk_service_service_logs FOREIGN KEY (service_id) REFERENCES services(id)
            ON DELETE SET NULL,
        CONSTRAINT fk_user_service_logs FOREIGN KEY (user_id) REFERENCES users(id)
            ON DELETE SET NULL
    )"
    execute_query "$query"

    query="
    CREATE TABLE IF NOT EXISTS service_env (
        id INT AUTO_INCREMENT PRIMARY KEY,
        key_name VARCHAR(100),
        value TEXT,
        service_id INT NOT NULL,
        CONSTRAINT fk_services_service_env FOREIGN KEY (service_id) REFERENCES services(id)
            ON DELETE CASCADE
    )"
    execute_query "$query"

    query="
    CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(50) UNIQUE NOT NULL,
        full_name VARCHAR(100),
        email VARCHAR(100)
    )"
    execute_query "$query"

    query="
    CREATE TABLE IF NOT EXISTS service_ports (
        id INT AUTO_INCREMENT PRIMARY KEY,
        host_port SMALLINT,
        container_port SMALLINT,
        protocol ENUM('tcp','udp') DEFAULT 'tcp'
    )"
    execute_query "$query"

    query="
    CREATE TABLE IF NOT EXISTS ports_services (
        port_id INT NOT NULL,
        service_id INT NOT NULL,
        PRIMARY KEY (port_id, service_id),
        ADD CONSTRAINT fk_service_ports_ports_services FOREIGN KEY (port_id) REFERENCES service_ports(id)
            ON DELETE CASCADE,
        ADD CONSTRAINT fk_services_ports_services FOREIGN KEY (service_id) REFERENCES services(id)
            ON DELETE CASCADE
    )"
}

#===== USER INPUT =====
ask_mysql_root_passwd()
{
    if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
        print_warning "MySQL root password is necessary to continue"
        read -s -p "MySQL root password (enter for empty): " MYSQL_ROOT_PASSWORD
        echo ""
    fi
}

#===== CRUD OPERATIONS - SERVICES =====