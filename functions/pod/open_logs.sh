#!/bin/bash

open_logs() {
    # Ensure that 'namespace' and 'pod' variables are set before calling this function
    if [[ -z "$namespace" || -z "$pod" ]]; then
        log_error "Namespace and pod must be set before calling open_logs"
        return 1
    fi

    local interrupted=0

    # Define a cleanup function to handle SIGINT (CTRL-C)
    cleanup() {
        echo
        kill "$LOG_PID" 2>/dev/null
        focus "Logs stopped. Press any key to continue..."
        interrupted=1
    }

    # Set the trap for SIGINT
    trap cleanup SIGINT

    # Prompt the user for the number of log lines to display
    while true; do
        clear_terminal
        echo -e "${GREEN}Container Logs > ${namespace} > ${pod}${NC}"
        echo

        read -p "How many log lines do you want to display? (default: 100, -1 for all): " lines
        lines=${lines:-100}  # Set default to 100 if no input is provided

        # Validate that 'lines' is an integer (positive or negative)
        if [[ "$lines" =~ ^-?[0-9]+$ ]]; then
            log_info "Displaying $lines log lines for pod: '$pod' in namespace: '$namespace'"
            break
        else
            echo
            log_warning "Invalid input for log lines: '$lines'"
            sleep 2
            echo
        fi
    done

    # Inform the user how to exit the logs view
    clear_terminal
    echo -e "${GREEN}Container Logs > ${namespace} > ${pod}${NC}"
    echo
    focus "[!] Press any key to stop displaying logs..."
    echo

    # Start kubectl logs in a background process
    kubectl logs -n "$namespace" --tail "$lines" -f "$pod" &
    LOG_PID=$!  # Save the PID of the logs process

    # Wait for user input to stop logs
    # The user can press any key or use CTRL-C to interrupt
    if read -n 1 -s; then
        # User pressed a key, kill the logs process
        kill "$LOG_PID" 2>/dev/null
    fi

    # After exiting the logs
    if [[ "$interrupted" -eq 0 ]]; then
        # User pressed a key to stop logs
        echo
        focus "Logs stopped. Press any key to continue..."
        read -n 1 -s
    fi

    # Remove the trap for SIGINT
    trap - SIGINT
}