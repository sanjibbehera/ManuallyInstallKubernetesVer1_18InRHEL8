IP_NW = "192.168.15."
KUBERNETES_MASTER_IP = 10
KUBERNETES_WORKERONE_NODE_IP = 11
KUBERNETES_WORKERTWO_NODE_IP = 12

$user = '' # Maybe insert your own username here
$password = '' # Maybe insert your own password here

$script = %{
if ! subscription-manager status; then
  sudo subscription-manager register --username=#{$user.strip} --password=#{$password.strip} --auto-attach
  sudo yum-config-manager
fi
}

Vagrant.configure("2") do |config|
    config.vm.box = "generic/rhel8"
	config.vm.provision "shell", inline: $script
    config.vm.define "kubernetes-rhel8-master" do |node|
        node.vm.provider "virtualbox" do |vb|
            vb.name = "kubernetes-rhel8-master"
            vb.memory = 2500
            vb.cpus = 2
        end
        node.vm.hostname = "kubernetes-rhel8-master"
        node.vm.network :private_network, ip: IP_NW + "#{KUBERNETES_MASTER_IP}"
        node.vm.network "forwarded_port", guest: 22, host: 3888

        node.vm.provision "setup-hosts", :type => "shell", :path => "rhel8/setup-hosts.sh" do |s|
            s.args = ["eth1"]
        end
        node.vm.provision "setup-dns", type: "shell", :path => "rhel8/update-dns.sh"
    end
    config.vm.define "workerone-rhel8-nodeone" do |node|
        node.vm.provider "virtualbox" do |vb|
            vb.name = "workerone-rhel8-nodeone"
            vb.memory = 3096
            vb.cpus = 2
        end
        node.vm.hostname = "workerone-rhel8-nodeone"
        node.vm.network :private_network, ip: IP_NW + "#{KUBERNETES_WORKERONE_NODE_IP}"
        node.vm.network "forwarded_port", guest: 22, host: 3777

        node.vm.provision "setup-hosts", :type => "shell", :path => "rhel8/setup-hosts.sh" do |s|
            s.args = ["eth1"]
        end
        node.vm.provision "setup-dns", type: "shell", :path => "rhel8/update-dns.sh"
		node.vm.provision "installDocker", type: "shell", :path => "rhel8/install-docker.sh"
    end
    config.vm.define "workertwo-rhel8-nodetwo" do |node|
        node.vm.provider "virtualbox" do |vb|
            vb.name = "workertwo-rhel8-nodetwo"
            vb.memory = 3096
            vb.cpus = 2
        end
        node.vm.hostname = "workertwo-rhel8-nodetwo"
        node.vm.network :private_network, ip: IP_NW + "#{KUBERNETES_WORKERTWO_NODE_IP}"
        node.vm.network "forwarded_port", guest: 22, host: 3666

        node.vm.provision "setup-hosts", :type => "shell", :path => "rhel8/setup-hosts.sh" do |s|
            s.args = ["eth1"]
        end
        node.vm.provision "setup-dns", type: "shell", :path => "rhel8/update-dns.sh"
		node.vm.provision "installDocker", type: "shell", :path => "rhel8/install-docker.sh"
    end
end