MODULE_NAME="pvc"
MODULE_DISPLAY="Manage PVC Storage"
MODULE_ENTRY_POINT="pvc_entry_point"

source "$BASE_DIR/functions/common/select_namespace.sh"
source "$BASE_DIR/functions/pvc/load_mounted_pvcs.sh"
source "$BASE_DIR/functions/pvc/mount_pvc.sh"
source "$BASE_DIR/functions/pvc/unmount_all.sh"
source "$BASE_DIR/functions/pvc/unmount_single.sh"

pvc_entry_point() {
    local option="$1"
    local param="$2"

    # Gestion des commandes raccourcies
    if [[ -n "$option" ]]; then
        case "$option" in
            -m)
                # Montage d'un PVC dans un namespace
                clear_terminal
                if [[ -z "$param" ]]; then
                    echo -e "${GREEN}Mount PVC Storage > Select Namespace${NC}"
                    select_namespace
                else
                    namespace="$param" # Définit le namespace à partir du paramètre
                fi

                if [[ -n "$namespace" ]]; then
                    mount_pvc
                else
                    log_warning "Namespace not specified or invalid" 'console'
                    sleep 2
                fi
                return
                ;;
            -u)
                # Démontage d'un PVC spécifique par namespace
                if [[ -z "$param" ]]; then
                    log_warning "Please specify a namespace to unmount" 'console'
                    sleep 2
                    return
                fi
                namespace="$param"
                load_mounted_pvcs

                # Récupérer les PVCs montés dans ce namespace
                local pvc_entries=$(echo "$MOUNTED_PVCS" | jq "[.[] | select(.namespace==\"$namespace\")]")
                local pvc_count=$(echo "$pvc_entries" | jq length)
                if [[ "$pvc_count" -eq 0 ]]; then
                    log_warning "No PVCs found in namespace '$namespace'" 'console'
                    sleep 2
                    return
                elif [[ "$pvc_count" -gt 1 ]]; then
                    log_error "Multiple PVCs are mounted in namespace '$namespace'. Please use the script interactively to unmount" 'console'
                    sleep 5
                    return
                fi

                # Extraction automatique du PVC et du port
                pvc=$(echo "$pvc_entries" | jq -r ".[0].pvc")
                port=$(echo "$pvc_entries" | jq -r ".[0].port")
                if [[ -n "$pvc" && -n "$port" ]]; then
                    unmount_single
                else
                    log_error "Failed to identify PVC or port for namespace '$namespace'" 'console'
                    sleep 2
                fi
                return
                ;;
            *)
                log_warning "Unknown option: $option" 'console'
                echo -e "\nUsage: freescript.sh pvc [-m [namespace]] | [-u [namespace]]"
                sleep 5
                return
                ;;
        esac
    fi

    # Mode interactif
    load_mounted_pvcs
    clear_terminal

    local pvc_list=$(echo "$MOUNTED_PVCS" | jq -c '.[]')
    local pvc_count=$(echo "$MOUNTED_PVCS" | jq length)

    # Si aucun PVC n'est monté, aller directement à "Mount PVC"
    if [[ -z "$pvc_list" || "$pvc_list" == "[]" || "$pvc_count" -eq 0 ]]; then
        log_info "No PVCs are currently mounted. Redirecting to Mount PVC option."
        clear_terminal
        echo -e "${GREEN}Mount PVC Storage > Select Namespace${NC}"
        select_namespace
        if [[ -n "$namespace" ]]; then
            mount_pvc
        fi
        return
    fi

    # Variables pour la navigation
    local current_index=0
    local pvc_map=()
    local i=0
    local options=("Mount PVC" "Exit")
    local total_count=$((pvc_count + ${#options[@]}))

    # Gestion interactive des PVC montés
    while true; do
        clear_terminal
        echo -e "${GREEN}PVC Storage Management${NC}\n"

        # Impression de l'en-tête
        printf "  %-*s %-*s %*s\n" 33 "PVC Name" 23 "Namespace" 8 "Port"
        local separator=$(printf '%*s' $((2 + 33 + 23 + 8 + 2)) '' | tr ' ' '-')
        echo -e "${DARK_GRAY}${separator}${NC}"

        # Impression des PVC montés
        i=0
        for entry in $pvc_list; do
            local pvc_name=$(echo "$entry" | jq -r '.pvc')
            local namespace=$(echo "$entry" | jq -r '.namespace')
            local port=$(echo "$entry" | jq -r '.port')

            pvc_map[$i]="$pvc_name"
            if [[ $i -eq $current_index ]]; then
                printf "${GREEN}> %-*s %-*s %*s${NC}\n" 33 "$pvc_name" 23 "$namespace" 8 "$port"
            else
                printf "  %-*s %-*s %*s\n" 33 "$pvc_name" 23 "$namespace" 8 "$port"
            fi
            ((i++))
        done

        echo -e "${DARK_GRAY}${separator}${NC}"

        # Impression des options supplémentaires
        for ((j = 0; j < ${#options[@]}; j++)); do
            if [[ $((pvc_count + j)) -eq $current_index ]]; then
                echo -e "${GREEN}> ${options[$j]}${NC}"
            else
                echo "  ${options[$j]}"
            fi
        done

        # Lecture des touches
        read -rsn1 key

        # Si on détecte la touche Échappement, on lit les deux caractères suivants (p. ex. "[A" ou "[B")
        if [[ "$key" == $'\x1b' ]]; then
            read -rsn2 -t 0.1 key2
            combined_key="$key$key2"
        else
            combined_key="$key"
        fi

        case "$combined_key" in
            $'\x1b[A'|k) # Flèche haut (Esc [A) OU 'k'
                if [[ $current_index -gt 0 ]]; then
                    current_index=$((current_index - 1))
                fi
                ;;

            $'\x1b[B'|j) # Flèche bas (Esc [B) OU 'j'
                if [[ $current_index -lt $((total_count - 1)) ]]; then
                    current_index=$((current_index + 1))
                fi
                ;;

            "") # Touche Entrée
                if [[ $current_index -lt $pvc_count ]]; then
                    pvc="${pvc_map[$current_index]}" # Capture le PVC sélectionné
                    unmount_single "$pvc"
                else
                    case $((current_index - pvc_count)) in
                        0) # Mount PVC
                            clear_terminal
                            echo -e "${GREEN}Mount PVC Storage > Select Namespace${NC}"
                            select_namespace
                            if [[ -n "$namespace" ]]; then
                                mount_pvc
                            fi
                            ;;
                        1) # Exit
                            return
                            ;;
                    esac
                fi
                ;;

            *)
                log_warning "Invalid option" 'console'
                sleep 1
                ;;
        esac
    done
}
