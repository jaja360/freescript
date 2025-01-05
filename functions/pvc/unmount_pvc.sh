#!/bin/bash

source ./functions/deploy/scale_up.sh
source ./functions/openssh/check_openssh.sh
source ./functions/openssh/delete_openssh.sh
source ./functions/port/stop_port_forward.sh
source ./functions/session/session_remove.sh

#!/bin/bash

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
