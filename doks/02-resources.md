# Provisioning Compute Resources

### Download this github repository
    git clone https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8.git

### Important Notes.
    After you have downloaded the code, adapt the Vagrantfile with your RHEL credentials.
    It is blank and has to be filled with your credentials.
    $user = '' # Maybe insert your own username here
    $password = '' # Maybe insert your own password here
    should be configured with your crednetials:-
    $user = 'myusername' # Maybe insert your own username here
    $password = 'mypassword' # Maybe insert your own password here
    Save the file.
### Run Vagrant up
    vagrant up

<b>Result:</b>

    It will spinup 3 VMs. 1 Master VM for Control Plane and 2 Worker Nodes.

| VM | VM Name | Purpose | IP | 
| :---: | :---: | :---: | :---: | 
| kubernetes-rhel8-master | kubernetes-rhel8-master | Master | 192.168.15.10 | 
| workerone-rhel8-nodeone | workerone-rhel8-nodeone | Worker | 192.168.15.11 | 
| workertwo-rhel8-nodetwo | workertwo-rhel8-nodetwo | Worker | 192.168.15.12 | 

Important information about the VM's.
==============================
    Private Key Path: .vagrant/machines/<machine name>/virtualbox/private_key
    Docker is only installed in the Worker nodes.
    Default username is vagrant and has sudo rights in all the VMs.
    
Verify Environment.
==============================
* Default username to be used for ssh is 'vagrant'.
* Ensure that all the VM's are reachable by any ssh client like Putty or Mobaxterm or Terminus.
* Ensure you can SSH into these VMs using the IP and private keys.
* Ensure that each VM can reach other VM via ping command.
