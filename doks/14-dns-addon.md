# Deploying the DNS Cluster Add-on

### The DNS Cluster Add-on
Deploy the coredns cluster add-on:

    kubectl apply -f https://raw.githubusercontent.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/master/deployments/coredns.yaml
    
> Output:-

    serviceaccount/coredns created
    clusterrole.rbac.authorization.k8s.io/system:coredns created
    clusterrolebinding.rbac.authorization.k8s.io/system:coredns created
    configmap/coredns created
    deployment.apps/coredns created
    service/kube-dns created
    
    
List the pods created by the kube-dns deployment:

    kubectl get pods -l k8s-app=kube-dns -n kube-system
    
> Output:

    NAME                       READY   STATUS    RESTARTS   AGE
    coredns-5448995c8b-f52fq   1/1     Running   0          75s
    coredns-5448995c8b-lv4dd   1/1     Running   0          75s
    
### Verification

Create a busybox deployment:

    kubectl run  busybox --image=busybox:1.28 --command -- sleep 3600
    
List the pod created by the busybox deployment:

    kubectl get pods -l run=busybox
    
> Output:

    NAME      READY   STATUS    RESTARTS   AGE
    busybox   1/1     Running   0          87s
    
Execute a DNS lookup for the kubernetes service inside the busybox pod:
> Note: Please enable firewall for port 10250 on both worker nodes such that kube-apiserver can connect kubelet.  
sudo firewall-cmd --permanent --add-port=10250/tcp  
sudo firewall-cmd --reload

    kubectl exec -ti busybox -- nslookup kubernetes
    
> Output:

    Server:    10.96.0.10
    Address 1: 10.96.0.10 kube-dns.kube-system.svc.cluster.local

    Name:      kubernetes
    Address 1: 10.96.0.1 kubernetes.default.svc.cluster.local
    
Next: []()

