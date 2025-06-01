#!/bin/bash

source /vagrant/scripts/ubuntu/common.sh

init_kubernetes() {
  echo "Starting Kubernetes..."

  sudo kubeadm init --pod-network-cidr=${POD_NETWORK_CIDR} --kubernetes-version=${K8S_VERSION%-*} --apiserver-advertise-address=${NODE_SERVER_IP}
}

remove_control_plane_taint() {
  kubectl taint nodes --all node-role.kubernetes.io/control-plane-
}

install_cni() {
  echo "Applying calico CNI plugin..."
  kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
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