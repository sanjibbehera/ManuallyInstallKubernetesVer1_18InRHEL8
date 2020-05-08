# Installing the Client Tools

### Access all VMs

Generate Key Pair on kubernetes-rhel8-master node $ssh-keygen  
Leave all settings to default.  
View the generated public key ID at:
    
    $cat .ssh/id_rsa.pub
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAA......8BtvJLJs= vagrant@kubernetes-rhel8-master
    
Move public key of master to rest VMs.  
Important Note:  
Copy the content of file 'id_rsa.pub' to authorized_keys in the target VMs.  
Make sure that authorized_keys file permissions are 600 & .ssh folder to be 700.

Install kubectl
=====================
The kubectl. command line utility is used to interact with the Kubernetes API Server.  
Download and install kubectl from the official release binaries.  
Make sure that the file is downloaded in the Master VM for this scenario.

    wget https://storage.googleapis.com/kubernetes-release/release/v1.18.2/bin/linux/amd64/kubectl
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/

Verification
=====================
Verify <b>kubectl</b> version 1.18.2 or higher is installed:
    
    kubectl version --client
    
> Output:

    Client Version: version.Info{Major:"1", Minor:"18", GitVersion:"v1.18.2", GitCommit:"52c56ce7a8272c798dbc29846288d7cd9fbae032", GitTreeState:"clean", BuildDate:"2020-04-16T11:56:40Z", GoVersion:"go1.13.9", Compiler:"gc", Platform:"linux/amd64"}
    
Next: [Create Certificates](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/04-create_certificates.md)
