# Manually Install Kubernetes Cluster Ver1.18.2 in RHEL8 VMs

This GITHUB Repository show the steps to build manually Kubernetes Cluster on RHEL v8.2 VMs.  
Also we perform smoke test to check application deployments in the Cluster.  
We will also check the same via the Kubernetes Dashboard.

Cluster Details.
=====================
Information about the components in the Kubernetes cluster.
* Kubernetes 1.18.2  
* Docker Container Runtime 18.09.1  
* CNI Container Networking 0.8.5
* Weave Networking  
* etcd 3.4.7
* CoreDNS 1.6.6

Steps to be executed.
=====================
* [Prequisites](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/01-prerequisites.md)
* [Compute Resources](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/02-resources.md)
* [Install Client Tools](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/03-Install-Client-Tools.md)
* [Create Certificates](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/04-create_certificates.md)
* [Kubernetes Configuration Files](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/05-kubernetes_configuration_files.md)
* [Encryption](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/06-data_encryption.md)
* [Bootstraping etcd](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/07-Bootstraping-etcd.md)
* [Bootstraping Control Plane](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/08-Bootstraping-Control-Panel.md)
* [Bootstraping Worker-1](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/09-Bootstraping-First-Worker-Node.md)
* [Bootstraping Worker-2](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/10-Bootstraping-Second-Worker-Node.md)
* [Configure kubectl](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/11-Configure-kubectl.md)
* [Configure POD Network](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/12-configure-pod-network.md)
* [Kube-apiserver to Kubelet](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/13-kube-apiserver-to-kubelet.md)
* [DNS Addon](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/14-dns-addon.md)
