#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load config file
source "$SCRIPT_DIR/config/config.sh"

# Load libraries
load_libraries()
{
    local libraries_dir="$LIB_DIRECTORY"
    local library_name

    for library in "$libraries_dir"/*.sh; do
        if [ -f "$library" ]; then
            library_name="$(basename "$library")"
            source "$library"
            echo "Loaded Library: $library_name"
        fi
    done
}

# Load Modules
load_modules()
{
    local modules_dir="$MODULES_DIRECTORY"
    local mmodule_name

    for module in "$modules_dir"/*.sh; do
        if [ -f "$module" ]; then
            module_name="$(basename "$module")"
            source "$module"
            print_info "Loaded Module: $module_name"
        fi
    done
}

# Selection Module Menu
menu_modules()
{
    echo "print modules"
}

# Main Menu
main_menu()
{
    local option=0

    while [ "$option" -eq 0 ]; do
        print_header

        cat 

    done
}

load_libraries

print_header
load_modules

wait_time 1

main_menu