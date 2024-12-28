#!/bin/bash

# Fonction pour vérifier si un pod openssh-server-* existe dans le namespace
check_openssh() {
    pod=$(kubectl get pods -n "$namespace" -o jsonpath='{.items[*].metadata.name}' | grep -E '^openssh-server-')

    if [[ -n "$pod" ]]; then
        log_info "OpenSSH pod found: '$pod' in namespace '$namespace'"
        return 0 # Pod trouvé
    fi

    log_info "No OpenSSH pod found in namespace '$namespace'"
    return 1 # Aucun pod trouvé
}