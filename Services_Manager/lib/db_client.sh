#!/bin/bash

#===== VERIFICATION/CONNECTION =====
mysql_check()
{
    #Checks if mysql is installed
    if command -v mysql >/dev/null 2>&1; then
        print_error "MySQL is not installed"
        return 1
    fi

    #Checks if mysql service is running
    if sudo systemctl is-active --quiet mysql; then
        print_error "MySQL service is not active"
        return 1
    fi

    #Checks mysql connection with credentials
    if ! mysql -u "$DB_USER" -p "$DB_PASSWD" -e "SELECT 1" >/dev/null 2>&1; then
        print_error "Can't connect to MySQL"
        print_warning "Check MySQL credentials in config/config.sh"

        return 1
    fi
}

execute_query()
{
    local query="$1"

    mysql -h "$DB_HOST" -p "$DB_PORT" -u "$DB_USER" -p "$DB_PASSWD" -D "$DB_NAME" -e "$query" 2> /dev/null
}

#===== DATABASE CREATION =====
db_credentials()
{
    echo "create credentials"
}

db_creation()
{
    if ! mysql_check; then
        return 1;
    fi

    local query

    #Create services table
    query="
    CREATE TABLE services (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(50) UNIQUE NOT NULL,
        type INT NOT NULL,
        status ENUM("running","stopped","error") DEFAULT "stopped",
        host VARCHAR(100) DEFAULT "localhost",
        description VARCHAR(100),
        image VARCHAR(200),
        config_path VARCHAR(200),
        port_id INT,
        user_id INT NOT NULL
    )"
    execute_ "$query"

    #Create logs table
    query="
    CREATE TABLE service_logs (
        id INT AUTO_INCREMENT PRIMARY KEY,
        action VARCHAR(50),
        details VARCHAR(200),
        ip_address VARCHAR(50),
        service_id INT NOT NULL,
        user_id INT NOT NULL
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

    query="
    CREATE TABLE users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(50) UNIQUE NOT NULL,
        full_name VARCHAR(100),
        email VARCHAR(100)
    )"

    #Create service ports table
    query="
    CREATE TABLE service_ports (
        id INT AUTO_INCREMENT PRIMARY KEY,
        host_port SMALLINT,
        container_port SMALLINT,
        protocol ENUM("tcp","udp") DEFAULT "tcp",
        service_id INT NOT NULL
    )"
    execute_query "$query"

    #Intermediate table services-service_pors
    query="
    CREATE TABLE ports_services (
        port_id INT,
        service_id INT
    )"
    execute_query "$query"

    #Services foreign key
    query="
    ALTER TABLE services
    ADD CONSTRAINT "fk_service_ports_service" FOREIGN KEY (port_id) REFERENCES service_ports(id)
    ADD CONSTRAINT "fk_users_services" FOREIGN KEY (user_id) REFERENCES users(id)"
    execute_query "$query"

    #Service logs foreign key
    query="
    ALTER TABLE service_logs
    ADD CONSTRAINT "fk_service_service_logs" FOREIGN KEY (service_id) REFERENCES services(id)
    ADD CONSTRAINT "fk_user_service_logs" FOREIGN KEY (user_id) REFERENCES users(id)"
    execute_query "$query"

    #Service environment foreign key
    query="
    ALTER TABLE service_env
    ADD CONSTRAINT "fk_services_service_env" FOREIGN KEY (service_id) REFERENCES services(id)"

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
}

#===== DATABASE INITIALIZATION =====
db_init()
{
    echo "initialize db"
}