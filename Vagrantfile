Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.disksize.size = '20GB'
  config.vm.provision :shell, path: "bootstrap.sh"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 4096
    vb.cpus = 4
  end
end
