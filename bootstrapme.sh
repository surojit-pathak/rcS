sudo yum install -y screen
sudo yum install -y vim
sudo yum install -y yum-utils
sudo yum install -y gcc
sudo yum install -y wget
sudo yum install -y git
sudo yum install -y cscope

sudo easy_install pip
if [ $? -ne 0 ]; then
    sudo rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
    sudo yum install -y python-pip
    sudo rpm -e epel-release
fi


# gets suro_git_clone
source ~/github-surojit-pathak/rcS/bashrc

cd
cd github-surojit-pathak
suro_git_clone https://github.com/surojit-pathak/openstack-tools.git
suro_git_clone https://github.com/surojit-pathak/mypylab.git
cd

_suro_init_pycscope

