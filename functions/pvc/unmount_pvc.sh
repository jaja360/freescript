source "$BASE_DIR/functions/deploy/scale_up.sh"
source "$BASE_DIR/functions/openssh/check_openssh.sh"
source "$BASE_DIR/functions/openssh/delete_openssh.sh"
source "$BASE_DIR/functions/port/stop_port_forward.sh"
source "$BASE_DIR/functions/session/session_remove.sh"

unmount_pvc() {
    if check_openssh; then
        delete_openssh
    else
        log_error "No OpenSSH pod found for PVC '$pvc' in namespace '$namespace'. Skipping unmount." 'console'
        sleep 2
        return
    fi

    if stop_port_forward && scale_up; then
        session_remove
    fi
}
