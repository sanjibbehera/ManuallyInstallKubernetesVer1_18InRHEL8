# Bootstrapping the etcd Cluster
Kubernetes components are stateless and store cluster state in etcd.

## Bootstrapping an etcd Cluster Member.
### Download and Install the etcd Binaries
Download the official etcd release binaries from the coreos/etcd GitHub project:

    wget -q --show-progress --https-only --timestamping \
	      https://github.com/coreos/etcd/releases/download/v3.4.7/etcd-v3.4.7-linux-amd64.tar.gz
        
Extract and install the etcd server and the etcdctl command line utility:

    {
      tar -xvf etcd-v3.4.7-linux-amd64.tar.gz
      sudo mv etcd-v3.4.7-linux-amd64/etcd* /usr/local/bin/
    }
    
### Configure the etcd Server

    {
      sudo mkdir -p /etc/etcd /var/lib/etcd
      sudo cp ca.crt etcd-server.key etcd-server.crt /etc/etcd/
    }
    
The instance internal IP address will be used to serve client requests and communicate with etcd cluster peers.  
Retrieve the internal IP address of the master(etcd) nodes:-

    INTERNAL_IP=$(ip a show eth1 | grep "inet " | awk '{print $2}' | cut -d / -f 1)
    
Each etcd member must have a unique name within an etcd cluster.

    ETCD_NAME=$(hostname -s)
    
Create the etcd.service systemd unit file:

    cat <<EOF | sudo tee /etc/systemd/system/etcd.service
    [Unit]
    Description=etcd
    Documentation=https://github.com/coreos

    [Service]
    ExecStart=/usr/local/bin/etcd \\
      --name ${ETCD_NAME} \\
      --cert-file=/etc/etcd/etcd-server.crt \\
      --key-file=/etc/etcd/etcd-server.key \\
      --peer-cert-file=/etc/etcd/etcd-server.crt \\
      --peer-key-file=/etc/etcd/etcd-server.key \\
      --trusted-ca-file=/etc/etcd/ca.crt \\
      --peer-trusted-ca-file=/etc/etcd/ca.crt \\
      --peer-client-cert-auth \\
      --client-cert-auth \\
      --initial-advertise-peer-urls https://${INTERNAL_IP}:2380 \\
      --listen-peer-urls https://${INTERNAL_IP}:2380 \\
      --listen-client-urls https://${INTERNAL_IP}:2379,https://127.0.0.1:2379 \\
      --advertise-client-urls https://${INTERNAL_IP}:2379 \\
      --initial-cluster-token etcd-cluster-0 \\
      --initial-cluster ${ETCD_NAME}=https://${INTERNAL_IP}:2380 \\
      --initial-cluster-state new \\
      --data-dir=/var/lib/etcd
    Restart=on-failure
    RestartSec=5

    [Install]
    WantedBy=multi-user.target
    EOF
    
### Start the etcd Server
> Important Note before starting etcd.  
ADAPT THE BELOW LINE in /etc/sudoers file.
[such that SYSTEMD can search binaries from /usr/local/bin]  
Default Entry:   secure_path = /sbin:/bin:/usr/sbin:/usr/bin  
After Adaptation: secure_path = /sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin

    {
      sudo systemctl daemon-reload
      sudo systemctl enable etcd
      sudo systemctl start etcd
    }
    
## Verification

List the etcd cluster members:

    sudo ETCDCTL_API=3 etcdctl member list \
      --endpoints=https://127.0.0.1:2379 \
      --cacert=/etc/etcd/ca.crt \
      --cert=/etc/etcd/etcd-server.crt \
      --key=/etc/etcd/etcd-server.key
      
> Output:

    86921b57f4d2323d, started, kubernetes-rhel8-master, https://192.168.15.10:2380, https://192.168.15.10:2379, false
    
### Error Handling.

    Even after the above steps, you may face issue while starting up the etcd processes, like the error snapshot below.
    
    [vagrant@kubernetes-rhel8-mastervm ~]$ sudo systemctl status etcd
	● etcd.service - etcd
   	Loaded: loaded (/etc/systemd/system/etcd.service; enabled; vendor preset: disabled)
   	Active: activating (auto-restart) (Result: exit-code) since Sat 2020-05-09 19:09:27 UTC; 2s ago
     	Docs: https://github.com/coreos
  	Process: 7670 ExecStart=/usr/local/bin/etcd --name kubernetes-rhel8-mastervm --cert-file=/etc/etcd/etcd-server.crt --key-	file=/etc/etcd/etcd-server.key --peer-ce>
 	Main PID: 7670 (code=exited, status=203/EXEC)
     
     Error in messages file under /var/log/messages will show like below:-
     May  9 19:09:54 kubernetes-rhel8-mastervm systemd[7690]: etcd.service: Failed to execute command: Permission denied
     May  9 19:09:54 kubernetes-rhel8-mastervm systemd[7690]: etcd.service: Failed at step EXEC spawning /usr/local/bin/etcd: Permission denied
     
     For the above error 'Permission denied' we need to adapt /etc/sudoers file, for which workaround solution has been mentioned above.

     Actual Solution for the above issue, is to execute the below command and then restrat etcd.
     sudo setenforce 0
      

    
Next: [Bootstrapping the Kubernetes Control Plane](https://github.com/sanjibbehera/ManuallyInstallKubernetesVer1_18InRHEL8/blob/master/doks/08-Bootstraping-Control-Panel.md)
