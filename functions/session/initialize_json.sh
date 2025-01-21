# Fonction pour initialiser le JSON et valider les variables
initialize_json() {
    if [[ -z "$pvc" || -z "$namespace" || -z "$port" ]]; then
        log_error "initialize_json nécessite que les variables 'pvc', 'namespace', et 'port' soient définies" 'console'
        return 1
    fi

    if [[ -f "$SESSION_FILE" && -s "$SESSION_FILE" ]]; then
        MOUNTED_PVCS=$(cat "$SESSION_FILE")
    else
        MOUNTED_PVCS='{"mounted_pvcs": []}'
    fi
}
