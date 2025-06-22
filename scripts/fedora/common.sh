# Variables
K8S_VERSION="1.32.0-1.1"
POD_NETWORK_CIDR="192.168.0.0/16"
NODE_SERVER_IP="192.168.56.101"

# Parse arguments
parse_args() {
  for arg in "$@"; do
    case $arg in
      --node-server-ip=*)
        NODE_SERVER_IP="${arg#*=}"
        shift
        ;;
      *)
        ;;
    esac
  done
}

setup_containerd() {
  echo "Setting up Containerd..."
  sudo tee /etc/modules-load.d/containerd.conf > /dev/null <<EOF
overlay
br_netfilter
EOF

  sudo modprobe overlay
  sudo modprobe br_netfilter

  sudo tee /etc/sysctl.d/99-kubernetes-cri.conf > /dev/null <<EOF
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.conf.default.rp_filter=1
net.ipv4.conf.all.rp_filter=1
EOF
  sudo sysctl --system

  sudo dnf install -y containerd
  sudo mkdir -p /etc/containerd
  containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
  sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
  sudo systemctl restart containerd
  sudo systemctl enable containerd
}

disable_firewall_and_configure_kernel() {
  sudo systemctl disable --now firewalld

  sudo tee /etc/sysctl.d/k8s.conf > /dev/null <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.conf.default.rp_filter=1
net.ipv4.conf.all.rp_filter=1
EOF

  sudo sysctl --system
}

disable_swap() {
  echo "Disabling swap..."
  sudo swapoff -a
}

install_kubernetes_components() {
  echo "Installing Kubernetes components..."

  sudo dnf install -y dnf-plugins-core
  sudo dnf config-manager --add-repo https://pkgs.k8s.io/core:/stable:/v1.32/rpm/
  sudo rpm --import https://pkgs.k8s.io/core:/stable:/v1.32/rpm/Release.key

  sudo dnf install -y kubelet-${K8S_VERSION} kubeadm-${K8S_VERSION} kubectl-${K8S_VERSION}

  echo "KUBELET_EXTRA_ARGS=\"--node-ip=${NODE_SERVER_IP}\"" | sudo tee /etc/sysconfig/kubelet

  sudo systemctl enable --now kubelet
}

setup_kubeconfig() {
  sudo rm -rf /vagrant/.kube
  sudo mkdir -p /vagrant/.kube
  sudo cp -i /etc/kubernetes/admin.conf /vagrant/.kube/config
  sudo chown $(id -u):$(id -g) /vagrant/.kube/config
  export KUBECONFIG=/vagrant/.kube/config
}