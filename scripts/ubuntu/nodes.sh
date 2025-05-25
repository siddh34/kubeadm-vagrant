#!/bin/bash

source /vagrant/scripts/ubuntu/common.sh


attach_to_master() {
    while [ ! -f /vagrant/join.sh ]; do
        echo "Waiting for /vagrant/join.sh from master..."
        sleep 5
    done

    # Run the join command
    bash /vagrant/join.sh
}

# Execution
parse_args "$@"
setup_containerd
disable_firewall_and_configure_kernel
disable_swap
install_kubernetes_components
attach_to_master