# Provisioning Pod Network

We chose to use CNI - weave as our networking option.

### Install CNI plugins.

Download the CNI Plugins required for weave on each of the worker nodes - workerone-rhel8-nodeone and workertwo-rhel8-nodetwo

    wget https://github.com/containernetworking/plugins/releases/download/v0.8.5/cni-plugins-linux-amd64-v0.8.5.tgz
    
Extract it to /opt/cni/bin directory.

    sudo tar -xzvf cni-plugins-linux-amd64-v0.8.5.tgz --directory /opt/cni/bin/
    
### Deploy Weave Network
Deploy weave network. Run only once on the master node.

    kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
    
Weave uses POD CIDR of 10.32.0.0/12 by default.

### Verification
List the registered Kubernetes nodes from the master node:

    kubectl get pods -n kube-system
    
> Output:

    NAME              READY   STATUS    RESTARTS   AGE
    weave-net-hr5zf   2/2     Running   0          1m
    weave-net-p96fr   2/2     Running   0          95s
    
Next: [Kube API Server to Kubelet Connectivity](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/13-kube-apiserver-to-kubelet.md)
