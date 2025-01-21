stop_port_forward() {
    if [[ -z "$port" ]]; then
        log_error "Variable 'port' must be defined before calling stop_port_forward" 'console'
        return 1
    fi

    log_info "Stopping port forwarding for local port $port"

    local pid=$(lsof -t -i:"$port")
    if [[ -n "$pid" ]]; then
        kill "$pid" 2>/dev/null
        if [[ $? -eq 0 ]]; then
            log_info "Port forwarding stopped for local port $port" 'console'
        else
            log_error "Failed to stop port forwarding for local port $port" 'console'
            return 1
        fi
    else
        log_warning "No port forwarding process found for local port $port" 'console'
    fi

    return 0
}
