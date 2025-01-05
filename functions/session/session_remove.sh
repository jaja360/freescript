#!/bin/bash

source ./functions/session/initialize_json.sh
source ./functions/session/validate_json.sh

# Fonction pour supprimer une entrée
session_remove() {
    initialize_json

    jq_command_result=$(jq --arg pvc "$pvc" --arg namespace "$namespace" \
        '.mounted_pvcs |= map(select(.pvc != $pvc or .namespace != $namespace))' \
        "$SESSION_FILE" 2>/dev/null)

    if [[ $? -ne 0 || -z "$jq_command_result" ]]; then
        log_error "Failed to update entry from session file. Invalid JSON or missing data" 'console'
        return 1
    fi

    validate_json

    echo "$jq_command_result" > "$SESSION_FILE"
    log_info "Successfully removed '$pvc' to the JSON file"
}
