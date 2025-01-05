source ./functions/pvc/unmount_pvc.sh

unmount_all() {
    local pvc_list=$(echo "$MOUNTED_PVCS" | jq -c '.[]')
    local unmounted_list=()

    for entry in $pvc_list; do
        pvc=$(echo "$entry" | jq -r '.pvc')
        namespace=$(echo "$entry" | jq -r '.namespace')

        if [[ -n "$pvc" && -n "$namespace" ]]; then
            clear_terminal
            echo -e "${GREEN}Unmount PVC Storage > ${namespace} > ${pvc}${NC}\n"
            if unmount_pvc; then
                unmounted_list+=("[${namespace}] ${pvc}")
            else
                log_warning "Failed to unmount PVC $pvc in namespace $namespace. Skipping" 'console'
            fi
        else
            log_warning "Skipping invalid entry in session: $entry" 'console'
        fi
    done

    clear_terminal
    echo -e "${GREEN}Unmount PVC Storage > Unmount All${NC}\n"
    if [[ ${#unmounted_list[@]} -gt 0 ]]; then
        log_info "The following PVCs were successfully unmounted:"
        for pvc_entry in "${unmounted_list[@]}"; do
            echo -e " - ${WHITE}${pvc_entry}${NC}"
        done
    else
        log_error "No PVCs were successfully unmounted"
    fi

    echo -e "\n${GREEN}All PVCs have been processed${NC}\n"
    focus "Press any key to continue..."
    read -n 1 -s
}
