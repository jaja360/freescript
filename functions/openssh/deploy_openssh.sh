deploy_openssh() {
    log_info "Deploying openssh-server using $pvc.yaml in namespace: $namespace"

    # Capturer la sortie de kubectl pour diagnostiquer les erreurs en cas d'échec
    if output=$(kubectl apply -f "$pvc.yaml" -n "$namespace" 2>&1); then
        log_info "Successfully deployed openssh-server using $pvc.yaml" 'console'
    else
        log_error "Failed to deploy openssh-server using $pvc.yaml in namespace: $namespace. Error: $output" 'console'
        return 1
    fi
}
