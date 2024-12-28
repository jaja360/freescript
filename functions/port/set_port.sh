#!/bin/bash

# Fonction pour obtenir le prochain port disponible
set_port() {
    log_info "Fetching next available port"

    if [[ -f "$SESSION_FILE" && -s "$SESSION_FILE" ]]; then
        current_ports=$(jq -r '.mounted_pvcs[].port' "$SESSION_FILE")
    else
        current_ports=""
    fi

    port=$BASE_PORT

    while echo "$current_ports" | grep -wq "$port"; do
        log_info "Port $port is already in use. Checking next available port..." 'console'
        ((port++))
        if [[ $port -ge 65535 ]]; then
            log_error "No available ports found" 'console'
            return 1
        fi
    done

    log_info "Next available port is $port" 'console'
    return 0
}