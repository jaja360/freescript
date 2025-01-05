#!/bin/bash

# Fonction pour trouver le déploiement associé au PVC
find_deployment() {
    deployment="$(
        kubectl get deployments -n "$namespace" \
            -o jsonpath='{range .items[*]}{.metadata.name}{" => "}{range .spec.template.spec.volumes[?(@.persistentVolumeClaim.claimName)]}{.persistentVolumeClaim.claimName}{" "}{end}{"\n"}{end}' \
        | grep "$pvc" \
        | head -n1 \
        | awk -F ' => ' '{print $1}'
    )"

    if [[ -z "$deployment" ]]; then
        echo
        log_warning "No deployment found that uses PVC '$pvc' in namespace '$namespace'. Skipping scale_down..." 'console'
        echo
        focus "Press any key to continue..."
        read -n 1 -s
        return 1
    else
        log_info "Found deployment '$deployment' using PVC '$pvc'" 'console'
    fi
}
