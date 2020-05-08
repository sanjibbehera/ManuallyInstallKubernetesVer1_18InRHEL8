# Provisioning a CA and Generating TLS Certificates

    We will use openssl tool to bootstrap a Certificate Authority, and generate TLS certificates 
    for the following components:-
    etcd, kube-apiserver, kube-controller-manager, kube-scheduler, kubelet, and kube-proxy.
    
### Certificate Authority.

I have used the master node to create all the required certificates.

    # Create private key for CA
    openssl genrsa -out ca.key 2048
    
    # Create CSR using the private key
    openssl req -new -key ca.key -subj "/CN=KUBERNETES-CA" -out ca.csr
    
    # Self sign the csr using its own private key
    openssl x509 -req -in ca.csr -signkey ca.key -CAcreateserial  -out ca.crt -days 365

> Results:-
    
    ca.crt
    ca.key
    
### The Admin Client Certificate.
Generate the admin client certificate and private key:

    # Generate private key for admin user
    openssl genrsa -out admin.key 2048
    
    # Generate CSR for admin user. Note the OU.
    openssl req -new -key admin.key -subj "/CN=admin/O=system:masters" -out admin.csr
    
    # Sign certificate for admin user using CA servers private key
    openssl x509 -req -in admin.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out admin.crt -days 365
    
Note that the admin user is part of the system:masters group.  
This is how we are able to perform any administrative operations on Kubernetes cluster using kubectl utility.

> Results:-

    admin.key
    admin.crt
    
### The Controller Manager Client Certificate.
Generate the kube-controller-manager client certificate and private key:

    openssl genrsa -out kube-controller-manager.key 2048
    openssl req -new -key kube-controller-manager.key -subj "/CN=system:kube-controller-manager" -out kube-controller-manager.csr
    openssl x509 -req -in kube-controller-manager.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out kube-controller-manager.crt -days 365
    
> Results:-

    kube-controller-manager.key
    kube-controller-manager.crt
    
### The Kube Proxy Client Certificate.
Generate the kube-proxy client certificate and private key:

    openssl genrsa -out kube-proxy.key 2048
    openssl req -new -key kube-proxy.key -subj "/CN=system:kube-proxy" -out kube-proxy.csr
    openssl x509 -req -in kube-proxy.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out kube-proxy.crt -days 365
    
> Results:-

    kube-proxy.key
    kube-proxy.crt
    

### The Scheduler Client Certificate.
Generate the kube-scheduler client certificate and private key:

    openssl genrsa -out kube-scheduler.key 2048
    openssl req -new -key kube-scheduler.key -subj "/CN=system:kube-scheduler" -out kube-scheduler.csr
    openssl x509 -req -in kube-scheduler.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out kube-scheduler.crt -days 365
    
> Results:-

    kube-scheduler.key
    kube-scheduler.crt
    

### The Kubernetes API Server Certificate.
The kube-apiserver certificate requires all names that various components may reach it to be part of the alternate names.  
The openssl command cannot take alternate names as command line parameter.  
So we must create a conf file for it:

    cat > openssl.cnf <<EOF
    [req]
    req_extensions = v3_req
    distinguished_name = req_distinguished_name
    [req_distinguished_name]
    [ v3_req ]
    basicConstraints = CA:FALSE
    keyUsage = nonRepudiation, digitalSignature, keyEncipherment
    subjectAltName = @alt_names
    [alt_names]
    DNS.1 = kubernetes
    DNS.2 = kubernetes.default
    DNS.3 = kubernetes.default.svc
    DNS.4 = kubernetes.default.svc.cluster.local
    IP.1 = 10.96.0.1
    IP.2 = 192.168.15.10
    IP.3 = 127.0.0.1
    EOF
    
Generates certs for kube-apiserver:-

    openssl genrsa -out kube-apiserver.key 2048
    openssl req -new -key kube-apiserver.key -subj "/CN=kube-apiserver" -out kube-apiserver.csr -config openssl.cnf
    openssl x509 -req -in kube-apiserver.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out kube-apiserver.crt -extensions v3_req -extfile openssl.cnf -days 365
    
> Result:-

    kube-apiserver.crt
    kube-apiserver.key
    

### The ETCD Server Certificate.
Similarly ETCD server certificate must have addresses of all the servers part of the ETCD cluster.  
The openssl command cannot take alternate names as command line parameter.  
So we must create a conf file for it:

    cat > openssl-etcd.cnf <<EOF
    [req]
    req_extensions = v3_req
    distinguished_name = req_distinguished_name
    [req_distinguished_name]
    [ v3_req ]
    basicConstraints = CA:FALSE
    keyUsage = nonRepudiation, digitalSignature, keyEncipherment
    subjectAltName = @alt_names
    [alt_names]
    IP.1 = 192.168.15.10
    IP.2 = 127.0.0.1
    EOF
    
Generates certs for ETCD:

    openssl genrsa -out etcd-server.key 2048
    openssl req -new -key etcd-server.key -subj "/CN=etcd-server" -out etcd-server.csr -config openssl-etcd.cnf
    openssl x509 -req -in etcd-server.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out etcd-server.crt -extensions v3_req -extfile openssl-etcd.cnf -days 365
    
> Result:-

    etcd-server.key
    etcd-server.crt
    
### The Service Account Key Pair.
The Kubernetes Controller Manager leverages a key pair to generate and sign service account tokens.  
Generate the service-account certificate and private key:

    openssl genrsa -out service-account.key 2048
    openssl req -new -key service-account.key -subj "/CN=service-accounts" -out service-account.csr
    openssl x509 -req -in service-account.csr -CA ca.crt -CAkey ca.key -CAcreateserial  -out service-account.crt -days 365
    
> Result:-

    service-account.key
    service-account.crt
    
Next: [Generating Kubernetes Configuration Files for Authentication](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/05-kubernetes_configuration_files.md)
