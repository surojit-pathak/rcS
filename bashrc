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
