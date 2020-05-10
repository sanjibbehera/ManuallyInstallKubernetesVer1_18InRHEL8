# Bootstraping Helm

Execute the below command to download helm.

    wget -q --show-progress --https-only --timestamping \
        https://get.helm.sh/helm-v3.2.1-linux-amd64.tar.gz

Extract and install the helm utility:

    {
      tar -zxvf helm-v3.2.1-linux-amd64.tar.gz
      sudo mv linux-amd64/helm /usr/local/bin/helm
    }
    
### Verification
Verify helm version 3.2.1 or higher is installed:

    helm version
    
> Output:

    version.BuildInfo{Version:"v3.2.1", GitCommit:"fe51cd1e31e6a202cba7dead9552a6d418ded79a", GitTreeState:"clean", GoVersion:"go1.13.10"}
    
### Add Helm Chart repository

    helm repo add stable https://kubernetes-charts.storage.googleapis.com/
    
> Output:

    "stable" has been added to your repositories
    
### Verification about Contexts.
Make sure that your Kubernetes CLI is using the right cluster context.

    kubectl config get-contexts
    
Once verified, update repository.

    helm repo update


### TASK 1 (Install Grafana via Helm)
Add HELM REPO

    helm repo add flagger https://flagger.app
    
Install Grafana Chart

    helm install grafana-sanjib flagger/grafana --version 1.4.0
    
> Note: Once the service is up and running, edit the service type to NodePort from ClusterIP to access from Web Browser.  
First find the Nodeport which is exposed after changing the service type via the command.  
> kubectl get svc grafana-sanjib  
NAME             TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE  
grafana-sanjib   NodePort   10.96.0.241   <none>        80:32222/TCP   27m  
Hence the URL will be 'http://192.168.17.11:32222/'



### TASK 2 (Install MongoDB via Helm)
Add HELM REPO

    helm repo add bitnami https://charts.bitnami.com/bitnami
    
> Please make sure that you have PV already deployed, since we want a persistent volume for MONGODB.  

    kubectl create -f https://raw.githubusercontent.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/master/deployments/pv-mongodb.yaml
    
> Output:  

    persistentvolume/task-pv-volume created

Install MongoDB.

    helm install bitnami/mongodb
    
> Output:

    helm install dev-mongodb bitnami/mongodb
    NAME: dev-mongodb
    LAST DEPLOYED: Sun May 10 09:51:04 2020
    NAMESPACE: default
    STATUS: deployed
    REVISION: 1
    TEST SUITE: None
    NOTES:
    ** Please be patient while the chart is being deployed **

    MongoDB can be accessed via port 27017 on the following DNS name from within your cluster:
        dev-mongodb.default.svc.cluster.local

    To get the root password run:

    export MONGODB_ROOT_PASSWORD=$(kubectl get secret --namespace default dev-mongodb -o jsonpath="{.data.mongodb-root-password}" | base64 --decode)

    To connect to your database run the following command:

    kubectl run --namespace default dev-mongodb-client --rm --tty -i --restart='Never' --image docker.io/bitnami/mongodb:4.2.6-debian-10-r23 --command -- mongo admin --host dev-mongodb --authenticationDatabase admin -u root -p $MONGODB_ROOT_PASSWORD

    To connect to your database from outside the cluster execute the following commands:

    kubectl port-forward --namespace default svc/dev-mongodb 27017:27017 &
    mongo --host 127.0.0.1 --authenticationDatabase admin -p $MONGODB_ROOT_PASSWORD
    
### Verification.

    I have changed the service type to NodePort from ClusterIP, such that I can access it from my host commandline.  
    Since I have mongo client already installed in my laptop, the below command was used to connect the DB.
    mongo --host 192.168.17.11 --port 32575 --authenticationDatabase admin -p <DBPASSWORD>
    
### TASK 3 (Install Jenkins via Helm)
Add HELM REPO

    helm repo add bitnami https://charts.bitnami.com/bitnami
    
> Please make sure that you have PV already deployed, since we want a persistent volume for JENKINS.  

    https://raw.githubusercontent.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/master/deployments/pv-jenkins-bitnmami.yaml
    
> Output:

    persistentvolume/jenkins-bitnami-pv created
    
### Install JENKINS.

    helm install dev-jenkins bitnami/jenkins --set jenkinsUsername=admin -f https://raw.githubusercontent.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/master/deployments/jenkins-values.yaml
    
> Output:

    NAME: dev-jenkins
    LAST DEPLOYED: Sun May 10 17:11:21 2020
    NAMESPACE: default
    STATUS: deployed
    REVISION: 1
    TEST SUITE: None
    NOTES:
    ** Please be patient while the chart is being deployed **

    1. Get the Jenkins URL by running:

    ** Please ensure an external IP is associated to the dev-jenkins service before proceeding **
    ** Watch the status using: kubectl get svc --namespace default -w dev-jenkins **

      export SERVICE_IP=$(kubectl get svc --namespace default dev-jenkins --template "{{ range (index .status.loadBalancer.ingress 0) }}{{.}}{{ end }}")
      echo "Jenkins URL: http://$SERVICE_IP/"

    2. Login with the following credentials

      echo Username: user
      echo Password: $(kubectl get secret --namespace default dev-jenkins -o jsonpath="{.data.jenkins-password}" | base64 --decode)
      
> Important Note to retrieve the password:  
Execute the below command to get the password.  
kubectl get secret --namespace default dev-jenkins -o jsonpath="{.data.jenkins-password}" | base64 --decode

### Accessing JENKINS URL.

> By default JENKINS Service runs as LoadBalancer Service Type, as we are working VMs and not on cloud,  
we need to change the service type to NodePort. Once the changes are made, verify the Jenkins Service.

    kubectl get svc dev-jenkins
    
> Output:

    NAME          TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)                      AGE
    dev-jenkins   NodePort   10.96.0.210   <none>        80:32559/TCP,443:30149/TCP   66m

> Hence the JENKINS can be accessed by the URL 'http://192.168.17.11:32559/'  
Make sure you decode the password from the above steps in order to login.


### Troubleshooting.
> You may face file system issues, like the below error.  
Error executing 'postInstallation': EACCES: permission denied, open '/bitnami/jenkins/.buildcomplete'  

Please remember that in order for Jenkins run correctly, we need to create the filesystem '/bitnami/jenkins' in Worker Node  
for persistent storage. Still after that when Jenkins Container tries to write under this filesystem, the filesystem permissions  
need to change  to userid '1001' as the owner of the filesystem, hence changing the ownership to 1001 should resolve the issue.    

The file jenkins-values.yaml contain the definition for the variable 'RunasUser' and value is 1001 and hence the owner should be 1001.

Next: [Smoke Test](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/17-smoke%20tests.md)
