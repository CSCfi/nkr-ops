# -*- mode: ruby -*-
# vi: set ft=ruby :

# This script is to be run by saying 'vagrant up' in this folder. This script
# should be run only when creating a local development environment.

# Pre-provisioner shell script installs Ansible into the guest and continues
# to provision rest of the system in the guest. Works also on Windows.

$script = <<SCRIPT
set -e
if [ ! -f /vagrant_bootstrap_done.info ]; then
  sudo yum -y update
  sudo yum -y install epel-release libffi-devel openssl-devel git python3-3.6.8 python3-devel-3.6.8
  python3 -m pip install --upgrade pip
  python3 -m pip install ansible
  su --login -c 'cd /shared/ansible && source install_requirements.sh && ansible-playbook site_provision.yml -e @./secrets/local_development.yml' vagrant
  sudo touch /vagrant_bootstrap_done.info
fi
SCRIPT

# The following runs on the guest when `vagrant destroy` is commanded, but
# _before_ the user answers the yes/no question about destroying.
$teardown = <<SCRIPT
rm -rf /shared/ansible/roles/ansible-zookeeper
rm -rf /shared/ansible/roles/ansible-role-java
SCRIPT


required_plugins = %w( vagrant-vbguest )
required_plugins.each do |plugin|
   exec "vagrant plugin install #{plugin};vagrant #{ARGV.join(" ")}" unless Vagrant.has_plugin? plugin || ARGV[0] == 'plugin'
end

Vagrant.configure("2") do |config|
  config.vm.define "nkr_local_dev_env" do |server|
    server.vm.box = "centos/7"
    server.vm.network :private_network, ip: "30.30.30.30"

    # Basic VM synced folder mount
    server.vm.synced_folder "./ansible", "/shared/ansible", :mount_options => ["dmode=775,fmode=775"]
    # server.vm.synced_folder "./nkr-index", "/shared/nkr-index", :mount_options => ["dmode=777,fmode=777"], create: true
    server.vm.synced_folder "./nkr-proxy", "/usr/local/nkr-proxy/nkr-proxy", :mount_options => ["dmode=777,fmode=777"], create: true
    server.vm.synced_folder "./RecordManager", "/usr/local/RecordManager", :mount_options => ["dmode=777,fmode=777"], create: true

    server.vm.provision "shell", inline: $script

    server.vm.provider "virtualbox" do |vbox|
        vbox.name = "nkr_local_development"
        vbox.gui = false
        vbox.memory = 2048
        vbox.customize ["modifyvm", :id, "--nictype1", "virtio"]
    end

    server.trigger.before :destroy do |trigger|
      trigger.warn = "Deleting roles ansible-zookeeper and ansible-role-java... " +
                     "If you choose not to destroy the VM, you need to re-install them " +
                     "by running /shared/ansible/install_requirements.sh`"
      trigger.run_remote = {inline: $teardown}
    end
  end
end
