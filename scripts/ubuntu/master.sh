#!/bin/bash

source /vagrant/scripts/ubuntu/common.sh

init_kubernetes() {
  echo "Starting Kubernetes..."
  sudo kubeadm init --pod-network-cidr=${POD_NETWORK_CIDR} --kubernetes-version=${K8S_VERSION%-*} --apiserver-advertise-address=${APISERVER_ADVERTISE_ADDRESS}
}

remove_control_plane_taint() {
  kubectl taint nodes --all node-role.kubernetes.io/control-plane-
}

install_cni() {
  kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/${CALICO_VERSION}/manifests/tigera-operator.yaml
  kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/${CALICO_VERSION}/manifests/custom-resources.yaml
}

print_join_command() {
    echo "To join worker nodes, run the following command on each worker node:"
    JOIN_CMD=$(kubeadm token create --print-join-command)
    echo "$JOIN_CMD" > /vagrant/join.sh
    chmod +x /vagrant/join.sh
}

# Main script execution
parse_args "$@"
setup_containerd
disable_firewall_and_configure_kernel
install_kubernetes_components
disable_swap
init_kubernetes
setup_kubeconfig
remove_control_plane_taint
install_cni
print_join_command