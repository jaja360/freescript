MODULE_NAME="logs"
MODULE_DISPLAY="Show Container Logs"
MODULE_ENTRY_POINT="logs_entry_point"

source ./functions/common/select_namespace.sh
source ./functions/common/select_pod.sh
source ./functions/pod/open_logs.sh

logs_entry_point() {
    local option="$1"
    local namespace="$2"

    if [[ "$option" == "-n" && -n "$namespace" ]]; then
        namespace="$namespace"
    else
        clear_terminal
        echo -e "${GREEN}Container Logs > Select Namespace${NC}"
        select_namespace
        if [[ -z "$namespace" ]]; then
            return
        fi
    fi

    clear_terminal
    echo -e "${GREEN}Container Logs > ${namespace} > Select Pod${NC}"
    select_pod
    if [[ -z "$pod" ]]; then
        return
    fi

    open_logs
}
