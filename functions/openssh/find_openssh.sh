#!/bin/bash

# Fonction pour rechercher le pod d'OpenSSH
find_openssh() {
    while [[ -z "$pod" && $((retries=90)) -gt 0 ]]; do
        pod=$(kubectl get pods -n "$namespace" --selector app=openssh-server --field-selector=status.phase=Running -o jsonpath='{.items[0].metadata.name}' 2>/dev/null)

        if [[ -z "$pod" ]]; then
            log_warning "Waiting for the OpenSSH pod to scale up in namespace: '$namespace'..." 'console'
            sleep 3
            ((retries--))
        fi
    done

    if [[ -z "$pod" ]]; then
        log_error "Failed to find the OpenSSH pod in namespace '$namespace'" 'console'
        return 1
    fi

    log_info "OpenSSH pod found: '$pod' in namespace '$namespace'" 'console'
    return 0
}