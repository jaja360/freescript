#!/bin/bash

# Function to list PVCs and select one
select_pvc() {
    echo
    log_info "Fetching available PVCs in namespace: $namespace"
    pvc_list=$(kubectl get pvc -n "$namespace" --no-headers -o custom-columns="NAME:.metadata.name")
    if [[ -z "$pvc_list" ]]; then
        log_error "No PVCs available in namespace: $namespace" 'console'
        sleep 2
        return 1
    fi

    echo "$pvc_list" | nl -w2 -s") "
    echo

    read -p "Please select an option: " choice

    pvc=$(echo "$pvc_list" | sed -n "${choice}p")
    if [[ -z "$pvc" ]]; then
        echo
        log_warning "Invalid selection. No PVC found for option: $choice in namespace: $namespace" 'console'
        sleep 2
        return 1
    fi
}