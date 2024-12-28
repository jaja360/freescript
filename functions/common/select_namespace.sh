#!/bin/bash

# Function to list namespaces and select one
select_namespace() {
    echo
    focus_alt "Fetching available namespaces." 'console'
    namespaces=$(kubectl get ns --no-headers -o custom-columns="NAME:.metadata.name")
    if [[ -z "$namespaces" ]]; then
        log_error "No namespaces available. Exiting namespace selection" 'console'
        sleep 2
        exit 1
    fi

    echo "$namespaces" | nl -w2 -s") "
    echo

    read -p "Please select an option: " choice

    namespace=$(echo "$namespaces" | sed -n "${choice}p")
    if [[ -z "$namespace" ]]; then
        echo
        log_warning "Invalid selection. No namespace found for option: $choice" 'console'
        sleep 2
        return 1
    fi

    # Récupère le premier déploiement trouvé dans le namespace sélectionné
    deployment="$(kubectl get deployment -n "$namespace" --no-headers -o custom-columns=":metadata.name" | head -n 1)"

    if [[ -n "$deployment" ]]; then
        log_info "Found deployment '$deployment' in namespace '$namespace'"
    else
        log_warning "No deployment found in namespace '$namespace'. Deployment is empty"
        # À toi de voir si tu retournes 1 ou pas :
        # return 1
    fi
}