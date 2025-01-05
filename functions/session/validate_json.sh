# Fonction pour valider le JSON
validate_json() {
    local json_data="$1"

    echo "$json_data" | jq empty > /dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        log_error "Generated JSON is invalid" 'console'
        return 1
    fi

    return 0
}
