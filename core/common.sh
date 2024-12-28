#!/bin/bash

trap "clear" EXIT

SESSION_FILE=$(realpath "./session.json")
LOG_FILE="freescript.log"
BASE_PORT=2022

truncate -s 0 "$LOG_FILE"

# ANSI Colors
GREEN='\033[0;32m'
DARK_GRAY='\033[90m'
WHITE='\033[37m'
BOLD='\033[1m'
NC='\033[0m'

# Header template
clear_terminal() {
    clear
echo -e "${DARK_GRAY}   ###                                             ${WHITE}##                 ${NC}"
echo -e "${DARK_GRAY}  ##                          ${WHITE}###                 ##             ##   ${NC}"
echo -e "${DARK_GRAY}  ##                         ${WHITE}## ##                               ##   ${NC}"
echo -e "${DARK_GRAY} ####   # ###   ###    ###   ${WHITE}##      ####  # ###  ###    ####   ####  ${NC}"
echo -e "${DARK_GRAY}  ##    ###    ## ##  ## ##  ${WHITE} ###   ##     ###     ##    ## ##   ##   ${NC}"
echo -e "${DARK_GRAY}  ##    ##     #####  #####  ${WHITE}   ##  ##     ##      ##    ## ##   ##   ${NC}"
echo -e "${DARK_GRAY}  ##    ##     ##     ##     ${WHITE}## ##  ##     ##      ##    ## ##   ##   ${NC}"
echo -e "${DARK_GRAY}  ##    ##      ###    ###   ${WHITE} ###    ####  ##     ####   ####     ##  ${NC}"
echo -e "${DARK_GRAY}  #                                                      ${WHITE}##           ${NC}"
echo -e "${DARK_GRAY}                                                         ${WHITE}##           ${NC}"
echo
}

# Logging template
log_info() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local message="[*] $1"
    if [[ "$2" == 'console' ]]; then
        echo -e "${DARK_GRAY}$message${NC}"
    fi
    echo "[$timestamp] $message" >> "$LOG_FILE"
}
log_warning() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local message="[!] $1"
    if [[ "$2" == 'console' ]]; then
        echo -e "\\e[33m$message\\e[0m"
    fi
    echo "[$timestamp] $message" >> "$LOG_FILE"
}
log_error() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local message="[X] $1"
    if [[ "$2" == 'console' ]]; then
        echo -e "\\e[31m$message\\e[0m"
    fi
    echo "[$timestamp] $message" >> "$LOG_FILE"
}


log_temp() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    local message="$1"
    local target="$2"

    echo -e "[INFO] $message"
}

# Text effect
focus() {
  local text="$1"
  for ((i=0; i<${#text}; i++)); do
    echo -n "${text:$i:1}"
    sleep 0.01
  done
  echo
}

focus_alt() {
    local message="[*] $1"
    local target="$2"
    echo -e "${DARK_GRAY}$message${NC}"
    echo
    sleep 1
    tput cuu1
    tput el
    tput cuu1
    tput el
}

# Log initial script setup
log_info "Starting script execution"
log_info "Session file: $SESSION_FILE"
log_info "Log file: $LOG_FILE"
log_info "Starting port: $BASE_PORT"