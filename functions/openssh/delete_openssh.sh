#!/bin/bash

delete_openssh() {
    if [[ -z "$namespace" ]]; then
        log_error "remove_openssh: Namespace not specified. Aborting removal." 'console'
        return 1
    fi

    log_info "Starting removal of OpenSSH deployment in namespace: '$namespace'" 'console'

    # Supprimer le déploiement OpenSSH
    if kubectl delete deployment openssh-server -n "$namespace" --ignore-not-found > /dev/null 2>&1; then
        log_info "Successfully removed deployment: 'openssh-server' in namespace: '$namespace'" 'console'
    else
        log_error "Failed to remove deployment: 'openssh-server' in namespace: '$namespace'" 'console'
        return 1
    fi

    # Attendre la suppression du pod OpenSSH
    log_info "Ensuring OpenSSH pod is deleted in namespace: '$namespace'" 'console'
    while true; do
        local pod_exists
        pod_exists=$(kubectl get pods -n "$namespace" --selector="app=openssh-server" --no-headers 2>/dev/null | wc -l)
        if [[ "$pod_exists" -eq 0 ]]; then
            log_info "OpenSSH pod deleted in namespace: '$namespace'" 'console'
            break
        fi
        log_warning "OpenSSH pod still exists in namespace: '$namespace'. Waiting..." 'console'
        sleep 2
    done

    return 0
}