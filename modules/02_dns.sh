MODULE_NAME="dns"
MODULE_DISPLAY="List DNS Names"
MODULE_ENTRY_POINT="dns_entry_point"

source ./functions/common/select_namespace.sh
source ./functions/dns/verbose.sh
source ./functions/dns/show_all.sh
source ./functions/dns/show_dns.sh

dns_entry_point() {
    local option="$1"
    local namespace="$2"

    case "$option" in
        -n)
            show_dns "$namespace"
            ;;
        -a)
            show_all
            ;;
        *)
            while true; do
                clear_terminal
                echo -e "${GREEN}DNS Management Menu${NC}\n"
                echo "1) Show All"
                echo "2) From Namespace"
                echo "3) Back"
                echo
                read -p "Please select an option: " choice

                case "$choice" in
                    1)
                        show_all
                        ;;
                    2)
                        show_dns
                        ;;
                    3)
                        return
                        ;;
                    *)
                        echo
                        log_warning "Invalid option: '$choice'. Please try again" 'console'
                        sleep 2
                        ;;
                esac
            done
            ;;
    esac
}
