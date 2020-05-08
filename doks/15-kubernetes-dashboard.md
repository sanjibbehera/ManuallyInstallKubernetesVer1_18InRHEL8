# Deploying the Dashboard UI

The Dashboard UI is not deployed by default. To deploy it, run the following command:

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0/aio/deploy/recommended.yaml
    
> Output:

    namespace/kubernetes-dashboard created
    serviceaccount/kubernetes-dashboard created
    service/kubernetes-dashboard created
    secret/kubernetes-dashboard-certs created
    secret/kubernetes-dashboard-csrf created
    secret/kubernetes-dashboard-key-holder created
    configmap/kubernetes-dashboard-settings created
    role.rbac.authorization.k8s.io/kubernetes-dashboard created
    clusterrole.rbac.authorization.k8s.io/kubernetes-dashboard created
    rolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
    clusterrolebinding.rbac.authorization.k8s.io/kubernetes-dashboard created
    deployment.apps/kubernetes-dashboard created
    service/dashboard-metrics-scraper created
    deployment.apps/dashboard-metrics-scraper created
    
## Accessing the Dashboard UI 
To protect your cluster data, Dashboard deploys with a minimal RBAC configuration by default.  
Currently, Dashboard only supports logging in with a Bearer Token.

### Command line proxy
You can access Dashboard using the kubectl command-line tool by running the following command:

    kubectl proxy --address=192.168.15.10
    
Kubectl will make Dashboard available at http://192.168.15.10:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/.
