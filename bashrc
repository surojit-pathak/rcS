# install pycscopde 
function _suro_init_pycscope ()
{
    cd
    mkdir -p github/portante/
    cd !$
    git clone https://github.com/portante/pycscope.git
    cd pycscope
    sudo python ./setup.py install
    cd
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

