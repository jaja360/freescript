#!/bin/bash

remove_yaml() {
    if [[ -z "$pvc" ]]; then
        log_error "remove_yaml: PVC variable is not set. Aborting deletion." 'console'
        return 1
    fi

    if [[ -f "${pvc}.yaml" ]]; then
        if rm -f "${pvc}.yaml"; then
            log_info "Successfully deleted YAML file: '${pvc}.yaml'" 'console'
        else
            log_error "Failed to delete YAML file: '${pvc}.yaml'" 'console'
            return 1
        fi
    else
        log_warning "YAML file '${pvc}.yaml' not found. Skipping deletion." 'console'
    fi

    return 0
}