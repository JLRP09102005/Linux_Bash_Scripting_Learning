#!/bin/bash

## COLORS
NC="\033[0m"

BLACK="\033[0;30m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
MAGENTA="\033[0;35m"
CYAN="\033[0;36m"
WHITE="\033[0;37m"

BOLD_BLACK="\033[1;30m"
BOLD_RED="\033[1;31m"
BOLD_GREEN="\033[1;32m"
BOLD_YELLOW="\033[1;33m"
BOLD_BLUE="\033[1;34m"
BOLD_MAGENTA="\033[1;35m"
BOLD_CYAN="\033[1;36m"
BOLD_WHITE="\033[1;37m"

BACKGROUND_BLACK="\033[0;40m"
BCKGROUND_RED="\033[0;41m"
BACKGROUND_GREEN="\033[0;42m"
BACKGROUND_YELLOW="\033[0;43m"
BACKGROUND_BLUE="\033[0;44m"
BACKGROUND_MAGENTA="\033[0;45m"
BACKGROUND_CYAN="\033[0;46m"
BACKGROUND_WHITE="\033[0;47m"

## MESSAGES
#Arg1 -> text to print
print_success()
{
    echo -e "${BOLD_GREEN}SUCCESS${NC} $1" >&2
}

#Arg1 -> text to print
print_error()
{
    echo -e "${BOLD_RED}ERROR${NC} $1" >&2
}

#Arg1 -> text to print
print_failed()
{
    echo -e "${BOLD_RED}FAILED${NC} $1" >&2
}

#Arg1 -> text to print
print_warning()
{
    echo -e "${BOLD_YELLOW}WARNING${NC} $1" >&2
}

#Arg1 -> text to print
print_info()
{
    echo -e "${BOLD_BLUE}INFO${NC} $1" >&2
}

print_header()
{
    clear
    echo -e "${GREEN}"

cat << "EOF"
    ╔═══════════════════════════════════════════════════════════════════╗
    ║                                                                   ║
    ║   ███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗███████╗    ║
    ║   ██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝██╔════╝    ║
    ║   ███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗  ███████╗    ║
    ║   ╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝  ╚════██║    ║
    ║   ███████║███████╗██║  ██║ ╚████╔╝ ██║╚██████╗███████╗███████║    ║
    ║   ╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝╚══════╝    ║
    ║                                                                   ║
    ║              Sistema de Gestión - MySQL Edition                   ║
    ║                                                                   ║
    ╚═══════════════════════════════════════════════════════════════════╝
EOF

    echo -e "${NC}"
}

## INTERACTION
press_enter_continue()
{
    echo ""
    read -p "Press enter to continue..."
}

confirm()
{
    local message="$1"
    read -p "$message (y/n): " response
    [[ "$response" =~ ^[yY]([eE][sS])?$ ]]
}

## DECORATION
#Arg1 -> time to wait
wait_time()
{
    sleep "$1"
}

print_divider()
{
    echo "════════════════════════════════════════════════════════"
}