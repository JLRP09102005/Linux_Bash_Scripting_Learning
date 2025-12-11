#!/bin/bash

## PERMISSIONS
is_root()
{
    [ "$EUID" -eq 0 ] #checks if the user that executed the program is root
}

requiere_root()
{
    if ! is_root; then
        print_error "This action requieres root privilegies"
        return 1
    else
        return 0
    fi
}

## VALIDATIONS
#Arg1 -> num to check
check_numeric_positive()
{
    [[ "$1" =~ ^[0-9]+$ ]]
}

#Arg1 -> module name
module_loaded()
{
    local module_name="$1"

    declare -f "${module_name}_menu" > /dev/null 2>&1    #Checks if the main function of the module exists
}

## LISTS
list_available_modules()
{
    local modules_dir="$MODULES_DIRECTORY"
    local module_name
    local modules=()

    for module in "$modules_dir"/*.sh; do
        if [ -f "$module" ]; then
            module_name=$(basename "$module" | tr -d ".sh")    # module_name=$(basename "$module" .sh)
            modules+=("$module_name")
        fi
    done

    printf "%s\n" "${modules[@]}"
}