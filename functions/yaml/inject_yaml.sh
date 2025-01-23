# Inject variables into the YAML file before deployment
inject_yaml() {
    if [[ ! -f "$BASE_DIR/functions/yaml/openssh-server.yaml" ]]; then
        log_error "YAML file 'openssh-server.yaml' not found. Cannot inject variables." 'console'
        exit 1
    fi

    sed "s|\${namespace}|$namespace|g; s|\${pvc}|$pvc|g" "$BASE_DIR/functions/yaml/openssh-server.yaml" > "$pvc.yaml"
    if [[ $? -eq 0 ]]; then
        log_info "Injected variable PVC '$pvc' into '$pvc.yaml'" 'console'
    else
        log_error "Failed to inject variables into 'openssh-server.yaml'" 'console'
        exit 1
    fi
}
