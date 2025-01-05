#!/bin/bash

# Montre tous les DNS
show_all() {
    log_info "User selected: Show All DNS Names"
    clear_terminal
    echo -e "${GREEN}List DNS Names > All${NC}"
    verbose
    focus "Press any key to continue..."
    read -n 1 -s
}
