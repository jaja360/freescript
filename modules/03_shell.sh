MODULE_NAME="shell"
MODULE_DISPLAY="Open Container Shell"
MODULE_ENTRY_POINT="shell_entry_point"

source ./functions/common/select_namespace.sh
source ./functions/common/select_pod.sh
source ./functions/pod/open_shell.sh

shell_entry_point() {
    local option="$1"
    local namespace="$2"

    if [[ "$option" == "-n" && -n "$namespace" ]]; then
        namespace="$namespace"
    else
        clear_terminal
        echo -e "${GREEN}Container Shell > Select Namespace${NC}"
        select_namespace
        if [[ -z "$namespace" ]]; then
            return
        fi
    fi

    clear_terminal
    echo -e "${GREEN}Container Shell > ${namespace} > Select Pod${NC}"
    select_pod
    if [[ -z "$pod" ]]; then
        return
    fi

    open_shell
}

export -f shell_entry_point
