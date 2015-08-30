# Install rsync
yum install -y rsync

# Install Ruby
yum install -y gcc openssl-devel libyaml-devel libffi-devel readline-devel zlib-devel gdbm-devel ncurses-devel
cd /usr/local/src
curl --remote-name https://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.3.tar.gz
tar zxf ruby-2.2.3.tar.gz
cd ruby-2.2.3
./configure
make
make install
cd

# Install Gems
/usr/local/bin/gem install geminabox
/usr/local/bin/gem install rack-rsync
/usr/local/bin/gem install unicorn

# Configure SSH User for Rsync
useradd gem_server -d /opt/gem_server
mkdir /opt/gem_server/.ssh
mv /home/vagrant/id_rsa /opt/gem_server/.ssh/id_rsa
mv /home/vagrant/id_rsa.pub /opt/gem_server/.ssh/authorized_keys
mv /home/vagrant/config /opt/gem_server/.ssh/config
chmod 700 /opt/gem_server/.ssh
chmod 600 /opt/gem_server/.ssh/id_rsa
chmod 600 /opt/gem_server/.ssh/authorized_keys
chmod 600 /opt/gem_server/.ssh/config

# Setup Gem in a box
mkdir /opt/gem_server/geminabox
mkdir /opt/gem_server/data
mv /home/vagrant/config.ru /opt/gem_server/geminabox/config.ru

# Create Systemd unit
mv /home/vagrant/gem_server.service /etc/systemd/system/gem_server.service
mv /home/vagrant/environments /opt/gem_server/geminabox/environments

# Change owner
chown -R gem_server. /opt/gem_server

# Start Gem Server
systemctl daemon-reload
systemctl enable gem_server
systemctl start gem_server

# Disable firewalld
systemctl stop firewalld
systemctl disable firewalld
