sudo yum install -y python-devel
sudo yum install -y openssl-devel
sudo yum install -y python-pip
sudo yum install -y mysql-devel
sudo yum install -y libxml2-devel
sudo yum install -y libxslt-devel
sudo yum install -y postgresql-devel
sudo yum install -y git-review
sudo yum install -y libffi-devel
sudo yum install -y gettext
sudo pip install virtualenv
sudo pip install setuptools-git
sudo pip install flake8
sudo pip install tox
sudo pip install testrepository
sudo pip install -U virtualenv

sudo mkdir -p /opt/stack
sudo chown $USER /opt/stack
git clone https://github.com/openstack-dev/devstack.git /opt/stack/devstack
cd ~
git clone https://git.openstack.org/openstack/magnum

cp ~/github-surojit-pathak/rcS/magnum.localrc /opt/stack/localrc
cp ~/github-surojit-pathak/rcS/magnum.local.sh /opt/stack/local.sh

cd /opt/stack/devstack
sed -i.bak "s/tempest,//" stackrc
sed -i.bak "/,horizon/d" stackrc
./stack.sh
