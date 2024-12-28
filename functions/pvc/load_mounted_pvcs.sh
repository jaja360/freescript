#!/bin/bash

# Load mounted PVCs from the session file
load_mounted_pvcs() {
    if [[ -f "$SESSION_FILE" ]]; then
        log_info "Loading mounted PVCs from session file"
        MOUNTED_PVCS=$(jq -c '.mounted_pvcs' "$SESSION_FILE" || echo "[]")
    else
        log_warning "Session file not found. Initializing an empty list of mounted PVCs" 'console'
        MOUNTED_PVCS="[]"
    fi

    # Validate the loaded data
    if [[ -z "$MOUNTED_PVCS" || "$MOUNTED_PVCS" != \[* ]]; then
        log_warning "Loaded data is invalid or empty. Resetting mounted PVCs to an empty array" 'console'
        MOUNTED_PVCS="[]"
    fi
}