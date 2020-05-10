# Deploying the Dashboard UI

The Dashboard UI is not deployed by default. To deploy it, run the following command:
> Please note that, I have modified the YAML file provided by Kuberenetes such that Kubernetes Dashboard service 
does not run as ClusterIP Service but as NodePort Service and can be accessed over any web browser.

    kubectl apply -f https://raw.githubusercontent.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/master/deployments/dashboard.yaml
    
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

### Create an admin user to access the Kubernetes Cluster Dashbaord.
Execute the below script.

    kubectl create -f https://raw.githubusercontent.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/master/deployments/createDashboardAdminUser.yaml
    
> Output:

    serviceaccount/admin-user created

### Create ClusterRoleBinding
We need to create only ClusterRoleBinding for our ServiceAccount. Hence execute the below script.

    kubectl create -f https://raw.githubusercontent.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/master/deployments/ClusterRoleBinding.yaml
    
> Output:

    clusterrolebinding.rbac.authorization.k8s.io/admin-user created
    
### Bearer Token
Now we need to find token we can use to log in. Execute following command:

    kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
    
> Output:

    Name:         admin-user-token-6w2ww
    Namespace:    kubernetes-dashboard
    Labels:       <none>
    Annotations:  kubernetes.io/service-account.name: admin-user
                  kubernetes.io/service-account.uid: 667eb47d-2278-43a3-87b3-f4235c5e6c81

    Type:  kubernetes.io/service-account-token

    Data
    ====
    ca.crt:     1001 bytes
    namespace:  20 bytes
    token:      eyJhbGciOiJSUzI1NiIsImtpZCI6IlpaZ2dtV0RMcHk4bW1RY1N0RjdwYVNCVnVzTmFYczIwclFETUNPS0RaU1EifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlcm5ldGVzLWRhc2hib2FyZCIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJhZG1pbi11c2VyLXRva2VuLTZ3Mnd3Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6ImFkbWluLXVzZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiI2NjdlYjQ3ZC0yMjc4LTQzYTMtODdiMy1mNDIzNWM1ZTZjODEiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6a3ViZXJuZXRlcy1kYXNoYm9hcmQ6YWRtaW4tdXNlciJ9.fKosb0LPTdjl7CjR55lu9r6VFSC5uAF0gp-w-5gQvAs1uFc6xXlBpBv70ZWzAb3W5FIvXA-huMYwLJFAQLHQEL_PJiJqF6PAEl9shBMbr9O8QbKZ4DaWzjCUz_nONPDBc5oNvkNPshP-u6IYi_FWnIA8fsRyz4N_HiA8X8yL8RRoz8lQH4X0XDh6jFL8O74zvI0oucZ_UPPn9zanVj9LBx1kVQ6gmr67L_w8W2hCnU5MhxAguO5nO5tomwhuO2puZUZJQLWltD3O-S0u0o8hJFL2MXi7dUZrPgeJo_j3c4IywcdTpyknATXc0aj1_7DmjEX24R5UFxRXzxoZ7cDxBA

> Important Note: Save this token to use the same for Dashboard login.

### Accessing Dashboarf from Web Browser.
As the Kubernetes Dashboard is exposed as NodePort Service, we need to find the ports for the same,  
please execute the below command to find out the ports:

    kubectl get svc -n kubernetes-dashboard -o wide
    
> Output:

    NAME                        TYPE       CLUSTER-IP   EXTERNAL-IP   PORT(S)          AGE   SELECTOR
    dashboard-metrics-scraper   NodePort   10.96.0.60   <none>        8000:32316/TCP   87m   k8s-app=dashboard-metrics-scraper
    kubernetes-dashboard        NodePort   10.96.0.41   <none>        443:31139/TCP    87m   k8s-app=kubernetes-dashboard

        
Hence the Dashboard will be available at https://192.168.15.11:31139/#/service?namespace=_all [Login Link]
> Important Note: The token which you had saved, should be used to login now.

Next: [Installing Helm](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/16-Helm.md)
