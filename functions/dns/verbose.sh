#!/bin/bash

verbose() {
    echo
    log_info "Entered DNS verbose function with chart names: ${*:-none}"

    chart_names=("${@}")

    # Get all namespaces and services
    if [[ ${#chart_names[@]} -eq 0 ]]; then
        log_info "No chart names provided. Fetching all services"
        services=$(kubectl get service --no-headers -A | sort -u)
    else
        pattern=$(IFS='|'; echo "${chart_names[*]}")
        log_info "Filtering services for charts matching pattern: $pattern"
        services=$(kubectl get service --no-headers -A | grep -E "^($pattern)[[:space:]]" | sort -u)
    fi

    if [[ -z $services ]]; then
        log_warning "No services found matching the criteria"
        echo "No services found"
        sleep 2
        return
    fi

    log_info "Services retrieved successfully"

    # Initialize max column widths
    max_namespace=12
    max_link=40
    max_port=5
    max_protocol=10

    while IFS=$'\n' read -r service; do
        namespace=$(echo "$service" | awk '{print $1}')
        svc_name=$(echo "$service" | awk '{print $2}')
        protocol="TCP"
        ports=$(echo "$service" | awk '{print $6}' | sed 's/\/TCP//g')
        dns_name="${svc_name}.${namespace}.svc.cluster.local"

        max_namespace=$(( ${#namespace} > max_namespace ? ${#namespace} : max_namespace ))
        max_link=$(( ${#dns_name} > max_link ? ${#dns_name} : max_link ))
        max_port=$(( ${#ports} > max_port ? ${#ports} : max_port ))
        max_protocol=$(( ${#protocol} > max_protocol ? ${#protocol} : max_protocol ))
    done <<< "$services"

    printf "%-${max_namespace}s %-${max_link}s %-${max_port}s %-s\n" "Namespace" "Cluster Link" "Port" "Protocol"
    separator=$(printf '%*s' $((max_namespace + max_link + max_port + max_protocol + 10)) '' | tr ' ' '-')
    echo -e "${DARK_GRAY}${separator}${NC}"

    prev_namespace=""
    while IFS=$'\n' read -r service; do
        namespace=$(echo "$service" | awk '{print $1}')
        svc_name=$(echo "$service" | awk '{print $2}')
        protocol="TCP"
        ports=$(echo "$service" | awk '{print $6}' | sed 's/\/TCP//g')
        dns_name="${svc_name}.${namespace}.svc.cluster.local"

        if [[ "$namespace" != "$prev_namespace" ]]; then
            if [[ -n "$prev_namespace" ]]; then
                echo
            fi
            prev_namespace="$namespace"
        fi

        printf "%-${max_namespace}s %-${max_link}s %-${max_port}s %-s\n" "$namespace" "$dns_name" "$ports" "$protocol"

    done <<< "$services"

    separator=$(printf '%*s' $((max_namespace + max_link + max_port + max_protocol + 10)) '' | tr ' ' '-')
    echo -e "${DARK_GRAY}${separator}${NC}\n"
}
