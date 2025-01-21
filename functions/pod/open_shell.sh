open_shell() {
    clear_terminal
    echo -e "${GREEN}Container Shell > ${namespace} > ${pod}${NC}\n"
    log_info "Opening shell in pod: '$pod' in namespace: '$namespace'"

    kubectl exec -n "$namespace" -it "$pod" -- sh -c '[ -e /bin/bash ] && exec /bin/bash || exec /bin/sh'
    if [[ $? -ne 0 ]]; then
        echo
        log_error "Failed to open shell for pod: '$pod' in namespace: '$namespace'" 'console'
        sleep 1
        return 1
    fi

    echo
    log_info "Shell session closed for pod: '$pod' in namespace: '$namespace'" 'console'
    sleep 1
}
