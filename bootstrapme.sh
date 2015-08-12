sudo yum install -y screen
sudo yum install -y vim
sudo yum install -y yum-utils
sudo yum install -y gcc
sudo yum install -y wget
sudo yum install -y git
sudo yum install -y cscope
sudo easy_install pip

cd
cd github-surojit-pathak
git clone https://github.com/surojit-pathak/openstack-tools.git
git clone https://github.com/surojit-pathak/mypylab.git
cd

source ~/github-surojit-pathak/rcS/bashrc
_suro_init_pycscope

