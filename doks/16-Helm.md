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
