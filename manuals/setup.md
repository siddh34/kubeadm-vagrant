# Cluster setup using containerd

## Step 1: Containerd setup

Network stuff

```bash
sudo cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

sudo cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
```

Check if the above settings are applied

```bash
sudo sysctl --system
```

## Step 2: Install containerd

```bash
sudo apt-get update
sudo apt-get install -y containerd
sudo mkdir -p /etc/containerd
cd /etc/containerd
sudo touch config.toml
sudo containerd config default | sudo tee config.toml
```

Note: Search the SystemdCgroup in config.toml file & make it true

```bash
sudo systemctl restart containerd
```

Disable firewall

```bash
sudo ufw allow 6443
```

## Step 3: Kernel config

```bash
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
```

```bash
sudo sysctl --system
```

## Step 4: Repo installation

```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
```

Disable swap

```bash
sudo swapoff -a
```

```bash
sudo apt-get update
sudo apt-get install -y kubelet=1.32.0-1.1 kubeadm=1.32.0-1.1 kubectl=1.32.0-1.1 cri-tools=1.32.0-1.1
sudo apt-mark hold kubelet kubeadm kubectl
sudo systemctl enable --now kubelet
```

## Step 5: Initialize the cluster

```bash
# sudo kubeadm reset
sudo kubeadm init --pod-network-cidr=192.168.0.0/16 --kubernetes-version=1.32.0
```

```bash
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=$HOME/.kube/config
```

## Step 6: Remove Taint

```bash
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```

## Step 7: Install CNI

```bash
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/tigera-operator.yaml

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.29.1/manifests/custom-resources.yaml
```

## Step 8: Verify

```bash
kubectl get nodes
kubectl run nginx --image=nginx
kubectl get pods
```