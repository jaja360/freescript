#!/bin/bash

# Write the mounted pvc to session file
update_session() {
    if echo "$MOUNTED_PVCS" | jq . > /dev/null 2>&1; then
        log_info "Saving mounted PVCs to session file"
        if jq -n --argjson pvcs "$MOUNTED_PVCS" '{mounted_pvcs: $pvcs}' > "$SESSION_FILE"; then
            log_info "Session file updated successfully"
        else
            log_error "Failed to update the session file" 'console'
        fi
    else
        log_error "Invalid JSON format in mounted PVCs. Session file not updated" 'console'
    fi
}