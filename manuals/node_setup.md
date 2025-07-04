# Node Setup using containerd

## Step 1: Containerd setup

Network stuff

```bash
# Load required kernel modules
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# Configure sysctl
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system
```

Install containerd

```bash
sudo apt-get update
sudo apt-get install -y containerd
```

Configure containerd

```bash
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null

sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

sudo systemctl restart containerd
sudo systemctl enable containerd
```

Disable swap

```bash
sudo swapoff -a
```

## Step 2: Kernel Parameter config

```bash
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

sudo sysctl --system
```

## Step 3: Configure K8s

```bash
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet=1.31.6-1.1 kubeadm=1.31.6-1.1 kubectl=1.31.6-1.1 cri-tools=1.31.1-1.1
sudo apt-mark hold kubelet kubeadm kubectl
echo "KUBELET_EXTRA_ARGS=\"--node-ip=192.168.56.102\"" >> /etc/default/kubelet
sudo systemctl enable --now kubelet
```

## Step 5: Make sure to add node using kubeadm join command

```bash
kubeadm join <control-plane-ip>:<port> --token <token> --discovery-token-ca-cert-hash sha256:<hash>
```