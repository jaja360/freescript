source "$BASE_DIR/functions/deploy/find_deployment.sh"
source "$BASE_DIR/functions/deploy/scale_down.sh"
source "$BASE_DIR/functions/openssh/check_openssh.sh"
source "$BASE_DIR/functions/openssh/deploy_openssh.sh"
source "$BASE_DIR/functions/openssh/find_openssh.sh"
source "$BASE_DIR/functions/port/set_port.sh"
source "$BASE_DIR/functions/port/start_port_forward.sh"
source "$BASE_DIR/functions/pvc/select_pvc.sh"
source "$BASE_DIR/functions/session/session_add.sh"
source "$BASE_DIR/functions/yaml/inject_yaml.sh"
source "$BASE_DIR/functions/yaml/remove_yaml.sh"

mount_pvc() {
    if [[ -z "$namespace" ]]; then
        clear_terminal
        echo -e "${GREEN}Mount PVC Storage > Select Namespace${NC}"
        select_namespace
        if [[ -z "$namespace" ]]; then
            return
        fi
    fi

    clear_terminal
    echo -e "${GREEN}Mount PVC Storage > ${namespace}${NC}"
    select_pvc
    if [[ -z "$pvc" ]]; then
        return
    fi

    clear_terminal
    echo -e "${GREEN}Mount PVC Storage > ${namespace} > ${pvc}${NC}\n"

    if check_openssh; then
        log_error "Cannot proceed because an OpenSSH pod is already running in namespace '$namespace'" 'console'
        sleep 2
        return
    fi

    if find_deployment; then
        if ! scale_down "$namespace" "$deployment"; then
            log_error "Scale down failed. Stopping $deployment..." 'console'
            sleep 2
            return
        fi
    fi

    if set_port && inject_yaml && deploy_openssh && session_add; then
        if remove_yaml && find_openssh; then
            start_port_forward
        fi
    else
        log_error "An error occurred during one of the steps. Aborting process."
        remove_yaml
        sleep 2
        return
    fi

    echo -e "\n${GREEN}Successfully mounted PVC ${BOLD}${pvc}${NC}${GREEN} in namespace ${BOLD}${namespace}${NC}${GREEN}.${NC}"
    log_info "Successfully mounted PVC $pvc in namespace $namespace"
    echo
    focus "Press any key to continue..."
    read -n 1 -s
}
