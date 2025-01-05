#!/bin/bash

MODULE_NAME="dbinfo"
MODULE_DISPLAY="Show information about all CNPG databases"
MODULE_ENTRY_POINT="show_db_info"

show_db_info() {
    namespaces=$(kubectl get secrets -A | grep -E "dbcreds|cnpg-main-urls" | awk '{print $1, $2}')

    ( printf "Application | Username | Password | Address | Port\n"
    echo "$namespaces" | while read ns secret; do
        app_name=$(echo "$ns")
        if [ "$secret" = "dbcreds" ]; then
            creds=$(kubectl get secret/$secret --namespace "$ns" -o jsonpath='{.data.url}' | base64 -d)
        else
            creds=$(kubectl get secret/$secret --namespace "$ns" -o jsonpath='{.data.std}' | base64 -d)
        fi

        username=$(echo "$creds" | awk -F '//' '{print $2}' | awk -F ':' '{print $1}')
        password=$(echo "$creds" | awk -F ':' '{print $3}' | awk -F '@' '{print $1}')
        addresspart=$(echo "$creds" | awk -F '@' '{print $2}' | awk -F ':' '{print $1}')
        port=$(echo "$creds" | awk -F ':' '{print $4}' | awk -F '/' '{print $1}')

        full_address="${addresspart}.${ns}.svc.cluster.local"
        printf "%s | %s | %s | %s | %s\n" "$app_name" "$username" "$password" "$full_address" "$port"
    done ) | column -t -s "|" | tee dbinfo.txt

    focus "Press any key to continue..."
    read -n 1 -s
}
