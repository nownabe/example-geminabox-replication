# -*- mode: ruby -*-
# vi: set ft=ruby :

IP_ADDRESSES = {
  primary: "192.168.33.29",
  secondary: "192.168.33.30"
}

Vagrant.configure(2) do |config|
  config.vm.box = "centos7.1"
  config.vm.box_url =
    "https://github.com/holms/vagrant-centos7-box/releases/download/7.1.1503.001/CentOS-7.1.1503-x86_64-netboot.box"

  config.vm.provision "file", source: "./id_rsa", destination: "~/id_rsa"
  config.vm.provision "file", source: "./id_rsa.pub", destination: "~/id_rsa.pub"
  config.vm.provision "file", source: "./config", destination: "~/config"
  config.vm.provision "file", source: "./config.ru", destination: "~/config.ru"
  config.vm.provision "file", source: "./gem_server.service", destination: "~/gem_server.service"
  config.vm.provision "file", source: "./provision.sh", destination: "~/provision.sh"

  %i(primary secondary).each do |role|
    config.vm.define role do |c|
      c.vm.hostname = "gem-#{role}"
      c.vm.network :private_network, ip: IP_ADDRESSES[role]

      c.vm.provision "shell", inline: <<-EOS
        cat <<EOF > /home/vagrant/environments
GEMINABOX_PRIMARY=#{IP_ADDRESSES[:primary]}
GEMINABOX_SECONDARY=#{IP_ADDRESSES[:secondary]}
GEMINABOX_MYADDRESS=#{IP_ADDRESSES[role]}
EOF
      EOS

      c.vm.provision "shell", inline: <<-EOS
        /bin/bash /home/vagrant/provision.sh
      EOS
    end
  end
end
