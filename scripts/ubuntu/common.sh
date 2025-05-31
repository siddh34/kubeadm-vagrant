# Variables
K8S_VERSION="1.32.0-1.1"
CALICO_VERSION="v3.29.1"
POD_NETWORK_CIDR="192.168.0.0/16"
APISERVER_ADVERTISE_ADDRESS="192.168.56.101"
DEBIAN_FRONTEND=noninteractive

# Parse arguments
parse_args() {
  for arg in "$@"; do
    case $arg in
      --api-server-ip=*)
        APISERVER_ADVERTISE_ADDRESS="${arg#*=}"
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

  sudo apt-get update
  sudo apt-get install -y containerd
  sudo mkdir -p /etc/containerd
  containerd config default | sudo tee /etc/containerd/config.toml >/dev/null
  sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
  sudo systemctl restart containerd
  sudo systemctl enable containerd
}

disable_firewall_and_configure_kernel() {
  sudo ufw disable

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

  sudo apt-get update
  sudo apt-get install -y apt-transport-https ca-certificates curl gpg
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

  sudo apt-get update
  sudo apt-get install -y kubelet=${K8S_VERSION} kubeadm=${K8S_VERSION} kubectl=${K8S_VERSION}
  sudo apt-mark hold kubelet kubeadm kubectl
  sudo systemctl enable --now kubelet
}

# TODO: FIX THIS
setup_kubeconfig() {
  sudo rm -rf /vagrant/.kube
  sudo mkdir -p /vagrant/.kube
  sudo cp -i /etc/kubernetes/admin.conf /vagrant/.kube/config
  sudo chown $(id -u):$(id -g) /vagrant/.kube/config
  export KUBECONFIG=/vagrant/.kube/config
}