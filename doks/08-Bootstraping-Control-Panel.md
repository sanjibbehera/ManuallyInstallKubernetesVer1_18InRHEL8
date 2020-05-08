# Bootstrapping the Kubernetes Control Plane
The following components will be installed on master node:  
Kubernetes API Server, Scheduler, and Controller Manager.

## Provision the Kubernetes Control Plane
Create the Kubernetes configuration directory:

    sudo mkdir -p /etc/kubernetes/config
    
### Download and Install the Kubernetes Controller Binaries:
Download the official Kubernetes release binaries:

    wget -q --show-progress --https-only --timestamping \
      "https://storage.googleapis.com/kubernetes-release/release/v1.18.2/bin/linux/amd64/kube-apiserver" \
      "https://storage.googleapis.com/kubernetes-release/release/v1.18.2/bin/linux/amd64/kube-controller-manager" \
      "https://storage.googleapis.com/kubernetes-release/release/v1.18.2/bin/linux/amd64/kube-scheduler"
      
### Install the Kubernetes binaries:

    {
      chmod +x kube-apiserver kube-controller-manager kube-scheduler
      sudo mv kube-apiserver kube-controller-manager kube-scheduler /usr/local/bin/
    }
    
### Configure the Kubernetes API Server

    {
      sudo mkdir -p /var/lib/kubernetes/

      sudo cp ca.crt ca.key kube-apiserver.crt kube-apiserver.key \
        service-account.key service-account.crt \
        etcd-server.key etcd-server.crt \
        encryption-config.yaml /var/lib/kubernetes/
    }
    

The instance internal IP address will be used to advertise the API Server to members of the cluster.  
Retrieve the internal IP address for the current compute instance:

    INTERNAL_IP=$(ip addr show eth1 | grep "inet " | awk '{print $2}' | cut -d / -f 1)
    
Verify it is set.

    echo $INTERNAL_IP
    
Create the kube-apiserver.service systemd unit file:

    cat <<EOF | sudo tee /etc/systemd/system/kube-apiserver.service
    [Unit]
    Description=Kubernetes API Server
    Documentation=https://github.com/kubernetes/kubernetes

    [Service]
    ExecStart=/usr/local/bin/kube-apiserver \\
      --advertise-address=${INTERNAL_IP} \\
      --allow-privileged=true \\
      --apiserver-count=3 \\
      --audit-log-maxage=30 \\
      --audit-log-maxbackup=3 \\
      --audit-log-maxsize=100 \\
      --audit-log-path=/var/log/audit.log \\
      --authorization-mode=Node,RBAC \\
      --bind-address=0.0.0.0 \\
      --insecure-bind-address=192.168.15.10 \\
      --insecure-port=8081 \\
      --client-ca-file=/var/lib/kubernetes/ca.crt \\
      --enable-admission-plugins=NodeRestriction,ServiceAccount \\
      --enable-swagger-ui=true \\
      --enable-bootstrap-token-auth=true \\
      --etcd-cafile=/var/lib/kubernetes/ca.crt \\
      --etcd-certfile=/var/lib/kubernetes/etcd-server.crt \\
      --etcd-keyfile=/var/lib/kubernetes/etcd-server.key \\
      --etcd-servers=https://192.168.15.10:2379 \\
      --event-ttl=1h \\
      --encryption-provider-config=/var/lib/kubernetes/encryption-config.yaml \\
      --kubelet-certificate-authority=/var/lib/kubernetes/ca.crt \\
      --kubelet-client-certificate=/var/lib/kubernetes/kube-apiserver.crt \\
      --kubelet-client-key=/var/lib/kubernetes/kube-apiserver.key \\
      --kubelet-https=true \\
      --runtime-config=api/all=true \\
      --service-account-key-file=/var/lib/kubernetes/service-account.crt \\
      --service-cluster-ip-range=10.96.0.0/24 \\
      --service-node-port-range=30000-32767 \\
      --tls-cert-file=/var/lib/kubernetes/kube-apiserver.crt \\
      --tls-private-key-file=/var/lib/kubernetes/kube-apiserver.key \\
      --v=3
    Restart=on-failure
    RestartSec=5

    [Install]
    WantedBy=multi-user.target
    EOF
    
### Configure the Kubernetes Controller Manager
Move the kube-controller-manager kubeconfig into place:

   sudo mv kube-controller-manager.kubeconfig /var/lib/kubernetes/
   
Create the kube-controller-manager.service systemd unit file:

    cat <<EOF | sudo tee /etc/systemd/system/kube-controller-manager.service
    [Unit]
    Description=Kubernetes Controller Manager
    Documentation=https://github.com/kubernetes/kubernetes

    [Service]
    ExecStart=/usr/local/bin/kube-controller-manager \\
      --address=0.0.0.0 \\
      --cluster-cidr=192.168.15.0/24 \\
      --cluster-name=kubernetes \\
      --cluster-signing-cert-file=/var/lib/kubernetes/ca.crt \\
      --cluster-signing-key-file=/var/lib/kubernetes/ca.key \\
      --kubeconfig=/var/lib/kubernetes/kube-controller-manager.kubeconfig \\
      --leader-elect=true \\
      --root-ca-file=/var/lib/kubernetes/ca.crt \\
      --service-account-private-key-file=/var/lib/kubernetes/service-account.key \\
      --service-cluster-ip-range=10.96.0.0/24 \\
      --use-service-account-credentials=true \\
      --v=2
    Restart=on-failure
    RestartSec=5

    [Install]
    WantedBy=multi-user.target
    EOF
    
### Configure the Kubernetes Scheduler
Move the kube-scheduler kubeconfig into place:

    sudo mv kube-scheduler.kubeconfig /var/lib/kubernetes/
    
Create the kube-scheduler.service systemd unit file:

    cat <<EOF | sudo tee /etc/systemd/system/kube-scheduler.service
    [Unit]
    Description=Kubernetes Scheduler
    Documentation=https://github.com/kubernetes/kubernetes

    [Service]
    ExecStart=/usr/local/bin/kube-scheduler \\
      --kubeconfig=/var/lib/kubernetes/kube-scheduler.kubeconfig \\
      --address=127.0.0.1 \\
      --leader-elect=true \\
      --v=2
    Restart=on-failure
    RestartSec=5

    [Install]
    WantedBy=multi-user.target
    EOF
    
### Start the Controller Services

    {
      sudo systemctl daemon-reload
      sudo systemctl enable kube-apiserver kube-controller-manager kube-scheduler
      sudo systemctl start kube-apiserver kube-controller-manager kube-scheduler
    }
    
> Allow up to 10 seconds for the Kubernetes API Server to fully initialize.
    
### Verification

    kubectl get componentstatuses --kubeconfig admin.kubeconfig
    
> Output:-

    NAME                 STATUS    MESSAGE             ERROR
    scheduler            Healthy   ok
    controller-manager   Healthy   ok
    etcd-0               Healthy   {"health":"true"}

> Make a HTTP request for the Kubernetes version info:

    curl  https://192.168.15.10:6443/version -k
    
> Output:-

    {
      "major": "1",
      "minor": "18",
      "gitVersion": "v1.18.2",
      "gitCommit": "52c56ce7a8272c798dbc29846288d7cd9fbae032",
      "gitTreeState": "clean",
      "buildDate": "2020-04-16T11:48:36Z",
      "goVersion": "go1.13.9",
      "compiler": "gc",
      "platform": "linux/amd64"
    }
    
Next: [Bootstrapping the Kubernetes First Worker Node](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/09-Bootstraping-First-Worker-Node.md)
