# Configure ETCD on arm ubuntu

## Step 1: Make some folders

```bash
mkdir binaries
cd binaries
```

## Step 2: Download and Copy the ETCD

```bash
sudo wget https://github.com/etcd-io/etcd/releases/download/v3.5.18/etcd-v3.5.18-linux-arm64.tar.gz

sudo tar -xzvf etcd-v3.5.18-linux-arm64.tar.gz

cd /home/vagrant/binaries/etcd-v3.5.18-linux-arm64/

sudo cp etcd etcdctl /usr/local/bin/
```

## Step 3: Start ETCD

```bash
cd /tmp
etcd
```

## Step 4: Check etcd is running properly or not

Note: Login into another terminal using `vagrant ssh vm1`

```bash
etcdctl put key1 "value1"
etcdctl get key1
```

OK! now this means binary is working fine

## Step 5: Configure a CA

```bash
mkdir certificates
cd certificates

# Creating Private Key and CSR:
openssl genrsa -out ca.key 2048
openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr

# Self-Sign the CSR
openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt -days 1000

# Remove csr
rm -f ca.csr

# check certificate
openssl x509 -in ca.crt -text -noout
```

## Step 6: Create configuration for etcd

```bash
cd /home/vagrant/certificates

openssl genrsa -out etcd.key 2048

# actual config for etcd, IP-1 is ip of machine check using `ip addr show` cmd
cat > etcd.cnf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
IP.1 = [IP-1]
IP.2 = 127.0.0.1
EOF

# csr
openssl req -new -key etcd.key -subj "/CN=etcd" -out etcd.csr -config etcd.cnf

# sign etcd csr
openssl x509 -req -in etcd.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out etcd.crt -extensions v3_req -extfile etcd.cnf -days 2000
```

## Step 7: Start and check etcd

```bash
cd /tmp
etcd --cert-file=/home/vagrant/certificates/etcd.crt --key-file=/home/vagrant/certificates/etcd.key --advertise-client-urls=https://127.0.0.1:2379 --listen-client-urls=https://127.0.0.1:2379
```

In new terminal check

```bash
etcdctl --endpoints=https://127.0.0.1:2379 --insecure-skip-tls-verify --insecure-transport=false put course "cks"

etcdctl --endpoints=https://127.0.0.1:2379 --insecure-skip-tls-verify --insecure-transport=false get course
```

## Step 8: Integrating with systemd

```bash
sudo mkdir /var/lib/etcd
chmod 700 /var/lib/etcd
```

```bash
cat <<EOF | sudo tee /etc/systemd/system/etcd.service
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
ExecStart=/usr/local/bin/etcd \\
  --cert-file=/home/vagrant/certificates/etcd.crt \\
  --key-file=/home/vagrant/certificates/etcd.key \\
  --trusted-ca-file=/home/vagrant/certificates/ca.crt \\
  --client-cert-auth \\
  --listen-client-urls https://127.0.0.1:2379 \\
  --advertise-client-urls https://127.0.0.1:2379 \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```

```bash
systemctl start etcd

systemctl enable etcd
```

```bash
systemctl status etcd
```

check logs

```bash
journalctl -u etcd
```