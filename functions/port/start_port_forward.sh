#!/bin/bash

# Fonction pour démarrer le port forwarding
start_port_forward() {
    if [[ -z "$namespace" || -z "$pod" || -z "$port" ]]; then
        log_error "Variables namespace, pod, and port must be defined before calling start_port_forward" 'console'
        return 1
    fi

    log_info "Starting port forwarding for pod $pod in namespace $namespace to local port $port"

    kubectl port-forward -n "$namespace" "pod/$pod" "$port:2222" &>/dev/null &
    if [[ $? -eq 0 ]]; then
        log_info "Port forwarding configured: $pod -> localhost:$port" 'console'
    else
        log_error "Failed to configure port forwarding for pod $pod in namespace $namespace on port $port" 'console'
        return 1
    fi
}