#!/bin/bash

scale_down() {
    log_info "Scaling down '$deployment' in namespace '$namespace' to 0 replicas" 'console'
    if ! kubectl scale deployment "$deployment" -n "$namespace" --replicas=0 &>/dev/null; then
        log_error "Failed to scale down '$deployment' in namespace '$namespace'" 'console'
        return 1
    fi

    while true; do
        local replicas
        local available
        replicas=$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.status.replicas}' 2>/dev/null || echo "")
        available=$(kubectl get deployment "$deployment" -n "$namespace" -o jsonpath='{.status.availableReplicas}' 2>/dev/null || echo "")
        replicas=${replicas:-0}
        available=${available:-0}

        if [[ "$replicas" -eq 0 && "$available" -eq 0 ]]; then
            log_info "Deployment '$deployment' in namespace '$namespace' is now at 0 replicas" 'console'
            break
        fi

        log_warning "Deployment '$deployment' still has replicas=$replicas, available=$available. Waiting..." 'console'
        sleep 2
    done

    return 0
}