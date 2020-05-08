# Generating Kubernetes Configuration Files for Authentication

In this section you will configure RBAC permissions to allow the Kubernetes API Server to access the Kubelet API  
on each worker node. Access to the Kubelet API is required for retrieving metrics, logs, and executing commands in pods.

## Client Authentication Configs

In this section you will generate kubeconfig files for the controller manager, kubelet, kube-proxy  
and scheduler clients and the admin user.

## The kube-proxy Kubernetes Configuration File.
Generate a kubeconfig file for the kube-proxy service:

    {
      kubectl config set-cluster kubernetes-cluster \
    --certificate-authority=ca.crt \
    --embed-certs=true \
    --server=https://192.168.15.10:6443 \
    --kubeconfig=kube-proxy.kubeconfig

     kubectl config set-credentials system:kube-proxy \
    --client-certificate=kube-proxy.crt \
    --client-key=kube-proxy.key \
    --embed-certs=true \
    --kubeconfig=kube-proxy.kubeconfig

     kubectl config set-context default \
    --cluster=kubernetes-cluster \
    --user=system:kube-proxy \
    --kubeconfig=kube-proxy.kubeconfig

     kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
    }
    
> Result:-

    kube-proxy.kubeconfig
    
## The kube-controller-manager Kubernetes Configuration File.
Generate a kubeconfig file for the kube-controller-manager service:

    {
     kubectl config set-cluster kubernetes-cluster \
    --certificate-authority=ca.crt \
    --embed-certs=true \
    --server=https://192.168.15.10:6443 \
    --kubeconfig=kube-controller-manager.kubeconfig

     kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=kube-controller-manager.crt \
    --client-key=kube-controller-manager.key \
    --embed-certs=true \
    --kubeconfig=kube-controller-manager.kubeconfig
 
     kubectl config set-context default \
    --cluster=kubernetes-cluster \
    --user=system:kube-controller-manager \
    --kubeconfig=kube-controller-manager.kubeconfig

     kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig
    }
    
> Result:-

    kube-controller-manager.kubeconfig
    
## The kube-scheduler Kubernetes Configuration File.
Generate a kubeconfig file for the kube-scheduler service:

    {
     kubectl config set-cluster kubernetes-cluster \
    --certificate-authority=ca.crt \
    --embed-certs=true \
    --server=https://192.168.15.10:6443 \
    --kubeconfig=kube-scheduler.kubeconfig

     kubectl config set-credentials system:kube-scheduler \
    --client-certificate=kube-scheduler.crt \
    --client-key=kube-scheduler.key \
    --embed-certs=true \
    --kubeconfig=kube-scheduler.kubeconfig

     kubectl config set-context default \
    --cluster=kubernetes-cluster \
    --user=system:kube-scheduler \
    --kubeconfig=kube-scheduler.kubeconfig

     kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig
    }
   
> Result:-

    kube-scheduler.kubeconfig
    
## The admin Kubernetes Configuration File.
Generate a kubeconfig file for the admin user:

    {
     kubectl config set-cluster kubernetes-cluster \
    --certificate-authority=ca.crt \
    --embed-certs=true \
    --server=https://192.168.15.10:6443 \
    --kubeconfig=admin.kubeconfig

     kubectl config set-credentials admin \
    --client-certificate=admin.crt \
    --client-key=admin.key \
    --embed-certs=true \
    --kubeconfig=admin.kubeconfig

     kubectl config set-context default \
    --cluster=kubernetes-cluster \
    --user=admin \
    --kubeconfig=admin.kubeconfig

     kubectl config use-context default --kubeconfig=admin.kubeconfig
     }
     
> Result:-

    admin.kubeconfig
    
> Copy the appropriate kube-proxy kubeconfig files to each worker instance:

    for instance in workerone-rhel8-nodeone workertwo-rhel8-nodetwo; do
      scp kube-proxy.kubeconfig ${instance}:~/certificates/
    done
    
Next: [Generating the Data Encryption Config and Key](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/06-data_encryption.md) 
