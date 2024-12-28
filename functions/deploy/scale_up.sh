#!/bin/bash

scale_up() {
    if [[ -z "$namespace" || -z "$pvc" ]]; then
        log_error "scale_up: Namespace or PVC not specified. Aborting replica restoration." 'console'
        return 1
    fi

    log_info "Searching for deployment associated with PVC: '$pvc' in namespace: '$namespace'" 'console'

    deployment=$(kubectl get deployment -n "$namespace" -o json | jq -r ".items[] | select(.spec.template.spec.volumes[]?.persistentVolumeClaim.claimName==\"$pvc\") | .metadata.name")

    if [[ -n "$deployment" ]]; then
        log_info "Found deployment: '$deployment' for PVC: '$pvc'. Restoring replicas" 'console'
        if kubectl scale deployment "$deployment" -n "$namespace" --replicas=1 > /dev/null 2>&1; then
            log_info "Replicas for deployment '$deployment' in namespace: '$namespace' restored to 1" 'console'
        else
            log_error "Failed to restore replicas for deployment '$deployment' in namespace: '$namespace'" 'console'
            return 1
        fi
    else
        log_warning "No deployment found for PVC: '$pvc' in namespace: '$namespace'" 'console'
        return 1
    fi

    return 0
}