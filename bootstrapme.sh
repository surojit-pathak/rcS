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

function setup_rc()
{
    _user=$1
    _file=$2
    TEMPFILE=`mktemp`
    chmod +w  $TEMPFILE
 
    # The enterprise version of rc should get preference
    # in case of re-definition
    if [ -f ~/github-surojit-pathak/rcS/$_file ]; then
        cp -f ~/github-surojit-pathak/rcS/${_file} $TEMPFILE
    fi 
    cat rcS/${_file} >> $TEMPFILE

    if [ $_user != "root" ]; then
        HOME_LOC=/home/${_user}
        CP="cp"
    else
        HOME_LOC=/root
        CP="sudo cp"
    fi
    $CP -f $TEMPFILE ${HOME_LOC}/.${_file}
    rm -rf $TEMPFILE
}

setup_rc $USER bashrc
source ~/.bashrc

setup_rc $USER screenrc
setup_rc $USER vimrc
setup_rc $USER gitrc
source ~/.gitrc
suro_create_alias_for_py_cmds

#setup_rc root bashrc
#setup_rc root screenrc
#setup_rc root vimrc
#setup_rc root gitrc
