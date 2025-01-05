# Function to wait for the pod to be ready
pod_status() {
    local POD=$(kubectl get pods -n "$namespace" --selector="app=openssh-server" --no-headers -o custom-columns="NAME:.metadata.name" | head -n 1)

    if [[ -z "$pod" ]]; then
        log_error "No pod found for PVC $pvc in namespace $namespace" 'console'
        return 1
    fi
    log_info "Waiting for pod: $pod in namespace: $namespace to be ready" 'console'
    while true; do
        STATUS=$(kubectl get pod "$pod" -n "$namespace" -o jsonpath='{.status.phase}' 2>/dev/null || echo "Unknown")
        if [[ "$STATUS" == "Running" ]]; then
            log_info "Pod $pod in namespace $namespace is ready" 'console'
            break
        fi
        log_warning "Pod $pod in namespace $namespace is not ready yet. Current status: $STATUS" 'console'
        sleep 2
    done
}
