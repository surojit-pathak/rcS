# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

if [ -f /etc/bash_completion.d/git ] ; then source /etc/bash_completion.d/git; fi
if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ] ; then source /usr/share/git-core/contrib/completion/git-prompt.sh; fi
is_git_ps_def=`declare -F | grep __git_ps2 | wc -l`
if [ $is_git_ps_def -eq 0 ]; then
    if [ ! -f ~/.git-prompt.sh ] ; then
        curl -o ~/.git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
    fi
    source ~/.git-prompt.sh
fi


export PS1='[\u@\h \W$(__git_ps1)]\$ '
export CSCOPE_EDITOR=vim
export vi=vim

function suro_add_git_mod_files ()
{
    for i in `git status | grep modified: | awk '{print $NF}'`; do git add $i; done
}

# Remove all the .rej files from 'git am'
function suro_rem_git_am_rej_files ()
{
    for i in `git status | grep ".rej$" | awk '{print $NF}'`; do rm "$i"; done
}

# Remove all the .rej files from 'git am'
function suro_git_rem_orig_files ()
{
    for i in `git status | grep ".orig$" | awk '{print $NF}'`; do rm "$i"; done
}

# function: Clone a gist, given its URL
function suro_gist_download ()
{
    git clone `echo "$1" | sed -e "s/^https:\/\//git\@/" | sed -e "s/\/gist\/[a-z]*\//:/" | sed -e "s/\$/.git/"`
}

# function: Clone a gist, given its URL
function suro_generate_export_list()
{
    if [ $# -eq 0 ]; then
        pat="=";
    else
        pat=$1;
    fi;
    for i in `env | grep $pat`;
    do
        echo export $i;
    done
}

function suro_apply_patch_till_max_idx () {
    if [ $# -lt 1 ] ; then echo Wrong number of Args; return 1; fi;
    if [ $# -ge 2 ] ; then unset dir; fi;
    count=0
    max=$1
    dir=${2:-"/default_path_to_patches"}

    for i in `ls $dir`;
    do
        j=`echo $i | cut -f1 -d\-`;
        if [ $j -ge $max ] ; then break; fi;
        git am < $dir/$i
        #echo $dir/$i
        if [ $? -ne 0 ] ; then break; fi;
        count=`expr $count + 1`
    done
}

# Throw a modified branch and create a new one from tag
function suro_git_branch_reset () {
    if [ $# -lt 1 ] ; then echo Wrong number of Args; break; fi;
    echo $0;
    branch=$1
    git checkout -f master;
    git branch -D $branch;
    git pull;
    git checkout -b $branch $branch;
    git branch -v
}

# function create alias for all py commands
function suro_create_alias_for_py_cmds()
{
    for i in `ls ~/Tools/pylets/*.py`;
    do
        exe=`basename $i | cut -f 1 -d.`;
        alias $exe=python\ $i ;
    done
}

# Remove old ssh fingerprint of a host
function suro_rem_old_ssh_fingerprint ()
{
     if [ $# -ne 1 ] ; then echo "usage: $FUNCNAME <hostname>"; return; fi

     HOST=$1
     FILE=~/.ssh/known_hosts
     grep -q $HOST $FILE
     if [ $? -ne 0 ]; then echo "$HOST is not known yet"; return; fi
 
     LINE=$( grep -n $HOST $FILE | cut -f1 -d: )
     sed -i.bak "${LINE}d" $FILE
}

# Check yaml syntax of a given file
function suro_validate_yaml () 
{ 
    python -c "import sys; import yaml;filed = open(sys.argv[1], 'r'); yaml.load(filed);" $1
}

# Function for assisting dev on devstack
function suro_devs_git_reapply ()
{   
    if [ -z $SDGR_DEV_BASE]; then printf "Enter val for dev-base:\n"; read -r val; SDGR_DEV_BASE=$val; fi
    if [ -z $SDGR_TOPIC]; then printf "Enter val for topic:\n"; read -r val; SDGR_TOPIC=$val; fi
    if [ -z $SDGR_PATCHF]; then printf "Enter val for patch-file:\n"; read -r val; SDGR_PATCHF=$val; fi
    # git checkout BP_magnum-service-list-dev-base;
    set -e
    git checkout $SDGR_DEV_BASE;
    git branch -D $SDGR_TOPIC;
    git checkout -b $SDGR_TOPIC;
    git branch -v;
    git am < $SDGR_PATCHF;
    git log -1
    set +e
}

function _suro_devs_version_snapshot ()
{
    cd /opt/stack;
    for i in `ls -l | grep ^d | awk '{print $NF}'`;
    do
        cd $i;
        if [ -d .git ]; then
            pwd;
            git branch -v;
        fi;
        cd -;
    done
}

# Function for taking snapshot of devstack version
function suro_devs_version_snapshot ()
{ 
    _suro_devs_version_snapshot | grep -v "/opt/stack$"
}

# Function for monitoring a bay creation of two node is complete
function suro_magdev_monitor_bay_creation ()
{
    time=0
    source /opt/stack/devstack/openrc admin admin

    while true; 
    do 
        count=`nova list | grep ACTIVE | wc -l`; 
        if [ $count -eq 2 ] ; then 
            echo "Done "; break; 
        fi; 
        time=`expr $time + 5`; 
        sleep 5; 
        de=`expr $time % 60`; 
        if [ $de -eq 0 ]; then 
            echo "Spent $time"; 
        fi; 
        if [ $time -gt 1200 ]; then 
            echo "No hope"; break; 
        fi; 
    done
}

# Function for returning the git top-of-the-tree
function suro_git_source_top ()
{ git rev-parse --show-toplevel; }

# Function for ensuring UT before pushing to gerrit
function suro_git_review ()
{
     srctop=`git rev-parse --show-toplevel`
     cd $srctop
     if [ -d '.tox' ] ; then
         tox -epep8 && tox -epy27
         if [ $? -ne 0 ]; then
             echo "Unit test failed, aborting"
             return 1
         fi
     else 
         echo "No unit test for this repo"
         echo "Use `git review` manually"
         return 1
     fi
     git review
}

# Function to ssh, removing old fingerprint, if exists
function suro_ssh ()
{
  ssh $1
  if [ $? -ne 0 ] ; then  suro_rem_old_ssh_fingerprint $1 ; ssh $1; fi
}

# For using ssh-agent and screen, we need to persist the sock location
if [[ -S "$SSH_AUTH_SOCK" && ! -h "$SSH_AUTH_SOCK" ]]; then
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock;
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock;

# My version of git clone
function suro_git_clone()
{
    URI=`echo $1 | cut -f2 -d\@`
    GITNAME=`basename $URI`
    DIRNAME=`echo $GITNAME | cut -f1 -d\.`
    if [ -d $DIRNAME ]; then
        cd $DIRNAME
        git pull
        cd -
    else 
        git clone $1
    fi
}

#install pycscopde 
function _suro_init_pycscope ()
{
    cd
    mkdir -p github/portante/
    cd github/portante/
    suro_git_clone https://github.com/portante/pycscope.git
    cd pycscope
    sudo python ./setup.py install
    cd
}


# Change git-repo to access to SSH for pushing change
function suro_git_set_ssh_url ()
{
    git remote -v
    url=`git remote -v | grep origin | grep fetch | awk '{print $2}'`
    is_http=$(python -c "import sys; print sys.argv[1].startswith('https')" $url)
    if [ $is_http = "True" ]; then
        proj=`basename $url`
        user_url=`dirname $url`
        user=`basename $user_url`
        mod_url=git@github.com:$user/$proj
        git remote set-url origin $mod_url
    fi
    git remote -v
}

# Look up for cetain words
function suro_lookup_certain_text ()
{
    DICT=$1
    TARGET=$2
    for i in `cat $DICT`; do grep -Irn $i $TARGET/*; done
}

function suro_bootstrap_host ()
{
    cd
    sudo yum install -y git

    # Run the following as a separate block
    mkdir github-surojit-pathak
    git clone https://github.com/surojit-pathak/rcS.git github-surojit-pathak/rcS
    github-surojit-pathak/rcS/bootstrapme.sh
    echo "Host git.corp.blah.com" >> ~/.ssh/config
    echo "  StrictHostKeyChecking no" >> ~/.ssh/config
    chmod 600 ~/.ssh/config
    git clone git@git.corp.blah.com:suro/rcS.git
    rcS/bootmestrap.sh
}

