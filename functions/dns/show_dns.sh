#!/bin/bash

# Montre les DNS pour un namespace
show_dns() {
    if [[ -z "$namespace" ]]; then
        clear_terminal
        echo -e "${GREEN}List DNS Names > Select Namespace${NC}"
        select_namespace
        if [[ -z "$namespace" ]]; then
            return
        fi
    fi

    clear_terminal
    echo -e "${GREEN}List DNS Names > ${namespace}${NC}"
    verbose "$namespace"
    log_info "Displayed DNS names for namespace: $namespace"
    focus "Press any key to continue..."
    read -n 1 -s
    unset namespace
}
