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