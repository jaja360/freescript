#!/bin/bash

# Function to check and install jq
healthcheck_jq() {
    if command -v jq >/dev/null 2>&1; then
        local jq_version=$(jq --version)
        log_info "jq is already installed. Version: $jq_version"
        return 0
    fi

    log_info "jq is not installed. Proceeding with installation..." 'console'

    if command -v apt >/dev/null 2>&1; then
        log_info "Using APT to install jq..." 'console'
        sudo apt update >> "$LOG_FILE" 2>&1
        sudo apt install -y jq >> "$LOG_FILE" 2>&1
    elif command -v yum >/dev/null 2>&1; then
        log_info "Using YUM to install jq..." 'console'
        sudo yum install -y epel-release >> "$LOG_FILE" 2>&1
        sudo yum install -y jq >> "$LOG_FILE" 2>&1
    elif command -v dnf >/dev/null 2>&1; then
        log_info "Using DNF to install jq..." 'console'
        sudo dnf install -y jq >> "$LOG_FILE" 2>&1
    elif command -v pacman >/dev/null 2>&1; then
        log_info "Using Pacman to install jq..." 'console'
        sudo pacman -Sy jq --noconfirm >> "$LOG_FILE" 2>&1
    elif command -v zypper >/dev/null 2>&1; then
        log_info "Using Zypper to install jq..." 'console'
        sudo zypper install -y jq >> "$LOG_FILE" 2>&1
    elif command -v brew >/dev/null 2>&1; then
        log_info "Using Homebrew to install jq..." 'console'
        brew install jq >> "$LOG_FILE" 2>&1
    else
        log_error "Unsupported system or package manager not found" 'console'
        return 1
    fi

    if command -v jq >/dev/null 2>&1; then
        local jq_version=$(jq --version)
        log_info "jq installed successfully. Version: $jq_version" 'console'
        sleep 2
        return 0
    else
        log_error "Failed to install jq. Please check for errors in $LOG_FILE" 'console'
        sleep 2
        return 1
    fi
}

# Main script execution
log_info "Starting health check"
healthcheck_jq
log_info "Health check completed"
