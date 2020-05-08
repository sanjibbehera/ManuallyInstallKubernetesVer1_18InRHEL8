# Configuring Kubectl

## The Admin Kubernetes Configuration File

### Generate a kubeconfig file suitable for authenticating as the admin user:
Execute the below on master VM.
    
    {
      kubectl config set-cluster kubernetes-cluster \
        --certificate-authority=ca.crt \
        --embed-certs=true \
        --server=https://192.168.15.10:6443

      kubectl config set-credentials admin \
        --client-certificate=admin.crt \
        --client-key=admin.key

      kubectl config set-context kubernetes-cluster \
        --cluster=kubernetes-cluster \
        --user=admin

      kubectl config use-context kubernetes-cluster
    }
    
## Verification
Check the health of the remote Kubernetes cluster:

    kubectl get componentstatuses
    
> Output:

    NAME                 STATUS    MESSAGE             ERROR
    scheduler            Healthy   ok
    controller-manager   Healthy   ok
    etcd-0               Healthy   {"health":"true"}

List the nodes in the remote Kubernetes cluster:

    kubectl get nodes
    
> Output:

    NAME                      STATUS   ROLES    AGE   VERSION
    workerone-rhel8-nodeone   NotReady <none>   8m    v1.18.2
    workertwo-rhel8-nodetwo   NotReady <none>   2m    v1.18.2

Note: It is OK for the worker node to be in a NotReady state.

Next: [Deploy Pod Networking](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/12-configure-pod-network.md)
