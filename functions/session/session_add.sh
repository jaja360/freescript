source "$BASE_DIR/functions/session/initialize_json.sh"
source "$BASE_DIR/functions/session/validate_json.sh"

# Fonction pour ajouter une entrée
session_add() {
    initialize_json

    jq_command_result=$(echo "$MOUNTED_PVCS" | jq --arg pvc "$pvc" --arg namespace "$namespace" --arg port "$port" \
        '.mounted_pvcs += [{pvc: $pvc, namespace: $namespace, port: $port}]' 2>/dev/null)

    if [[ $? -ne 0 || -z "$jq_command_result" ]]; then
        log_error "Failed to update entry from session file. Invalid JSON or missing data" 'console'
        return 1
    fi

    validate_json

    echo "$jq_command_result" > "$SESSION_FILE"
    log_info "Successfully added '$pvc' to the JSON file"
}
