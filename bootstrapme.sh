sudo yum install -y screen
sudo yum install -y vim
sudo yum install -y yum-utils
sudo yum install -y gcc
sudo yum install -y wget
sudo yum install -y git
sudo yum install -y cscope
sudo easy_install pip

# gets suro_git_clone
source ~/github-surojit-pathak/rcS/bashrc

cd
cd github-surojit-pathak
suro_git_clone https://github.com/surojit-pathak/openstack-tools.git
suro_git_clone https://github.com/surojit-pathak/mypylab.git
cd

_suro_init_pycscope

