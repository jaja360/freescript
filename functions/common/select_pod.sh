#!/bin/bash

# Function to select a pod in a given namespace
select_pod() {
    echo
    log_info "Fetching pods in namespace: $namespace"

    # Récupération brute des noms de pods (un par ligne)
    pods=$(kubectl get pods -n "$namespace" --no-headers -o custom-columns="NAME:.metadata.name")
    if [[ -z "$pods" ]]; then
        log_warning "No pods available in namespace: $namespace" 'console'
        sleep 2
        return 1
    fi

    # Compter le nombre de lignes (pods)
    local count=$(echo "$pods" | wc -l)

    # Si on n'a qu'un seul pod, on le sélectionne directement
    if [[ "$count" -eq 1 ]]; then
        pod=$(echo "$pods" | sed -n "1p")  # récupérer la première (et unique) ligne
        log_info "Pod selected: $pod in namespace: $namespace"
        return 0
    fi

    # Sinon, il y a plusieurs pods : on propose une sélection à l'utilisateur
    echo "$pods" | nl -w2 -s") "
    echo
    read -p "Please select an option: " choice

    # Valider que l'entrée est un nombre valide
    if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
        log_warning "Invalid input: '$choice' is not a number." 'console'
        sleep 2
        return 1
    fi

    pod=$(echo "$pods" | sed -n "${choice}p")
    if [[ -z "$pod" ]]; then
        echo
        log_warning "Invalid pod selection. No pod found for option: $choice in namespace: $namespace" 'console'
        sleep 2
        return 1
    fi

    log_info "Pod selected: $pod in namespace: $namespace"
    return 0
}
