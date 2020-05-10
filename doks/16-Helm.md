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
kubectl get svc grafana-sanjib  
NAME             TYPE       CLUSTER-IP    EXTERNAL-IP   PORT(S)        AGE  
grafana-sanjib   NodePort   10.96.0.241   <none>        80:32222/TCP   27m  
Hence the URL will be 'http://192.168.17.11:32222/'



### TASK 2 (Install MongoDB via Helm)
Add HELM REPO

    helm repo add bitnami https://charts.bitnami.com/bitnami
    
> Please make sure that you have PV already installed, since we want a persistent volume for MONGODB.  

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
    
Next: [Smoke Test](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/17-smoke%20tests.md)
