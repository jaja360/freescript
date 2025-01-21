source ./functions/pvc/unmount_pvc.sh

unmount_single() {
    if [[ -z "$namespace" || -z "$pvc" ]]; then
        log_error "unmount_pvc: Namespace or PVC not specified. Aborting unmount process." 'console'
        return 1
    fi

    clear_terminal
    echo -e "${GREEN}Unmount PVC Storage > ${namespace} > ${pvc}${NC}\n"

    unmount_pvc

    echo -e "\n${GREEN}Successfully unmounted PVC ${BOLD}${pvc}${NC}${GREEN} from namespace ${BOLD}${namespace}${NC}${GREEN}.${NC}"
    log_info "Successfully unmounted PVC $pvc from namespace $namespace"
    echo
    focus "Press any key to continue..."
    read -n 1 -s
}
