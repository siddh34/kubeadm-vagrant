# Configure api server on ubuntu arm

## Step 1: Download Kubernetes Server Binaries

```bash
cd binaries

sudo wget https://dl.k8s.io/v1.32.1/kubernetes-server-linux-arm64.tar.gz

sudo tar -xzvf kubernetes-server-linux-arm64.tar.gz

sudo ls -lh /home/vagrant/binaries/kubernetes/server/bin/

cd /home/vagrant/binaries/kubernetes/server/bin/

sudo cp kube-apiserver kubectl /usr/local/bin/
```

## Step 2: Certificate generation for service account and api server

```bash
cd /home/vagrant/certificates

# For api server
openssl genrsa -out api-etcd.key 2048
openssl req -new -key api-etcd.key -subj "/CN=kube-apiserver" -out api-etcd.csr
openssl x509 -req -in api-etcd.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out api-etcd.crt -days 2000

# For service account
openssl genrsa -out service-account.key 2048
openssl req -new -key service-account.key -subj "/CN=service-accounts" -out service-account.csr
openssl x509 -req -in service-account.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out service-account.crt -days 100
```

## Step 3: Start api server and check

```bash
sudo /usr/local/bin/kube-apiserver --advertise-address=159.65.147.161 --etcd-cafile=/home/vagrant/certificates/ca.crt --etcd-certfile=/home/vagrant/certificates/api-etcd.crt --etcd-keyfile=/home/vagrant/certificates/api-etcd.key --service-cluster-ip-range 10.0.0.0/24 --service-account-issuer=https://127.0.0.1:6443 --service-account-key-file=/home/vagrant/certificates/service-account.crt --service-account-signing-key-file=/home/vagrant/certificates/service-account.key --etcd-servers=https://127.0.0.1:2379
```

## Step 4: Move to systemd

```bash
sudo cat <<EOF | sudo tee /etc/systemd/system/kube-apiserver.service
[Unit]
Description=Kubernetes API Server
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-apiserver \
--advertise-address=165.22.212.16 \
--etcd-cafile=/home/vagrant/certificates/ca.crt \
--etcd-certfile=/home/vagrant/certificates/api-etcd.crt \
--etcd-keyfile=/home/vagrant/certificates/api-etcd.key \
--etcd-servers=https://127.0.0.1:2379 \
--service-account-key-file=/home/vagrant/certificates/service-account.crt \
--service-cluster-ip-range=10.0.0.0/24 \
--service-account-signing-key-file=/home/vagrant/certificates/service-account.key \
--service-account-issuer=https://127.0.0.1:6443 

[Install]
WantedBy=multi-user.target
EOF
```