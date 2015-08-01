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
     TMPFILE=/tmp/ssh_fingerprint_removal
     SSH $HOST >& $TMPFILE
     grep -q "Offending RSA" $TMPFILE
     if [ $? -ne 0 ]; then echo "$HOST is not known"; return; fi

     file_line=`grep "Offending RSA" $TMPFILE | awk '{print $NF}'`
     FILE=$( echo $file_line | cut -f1 -d: )
     LINE=$( echo $file_line | cut -f2 -d: )
     sed -e "$LINEd" $FILE > $FILE
}
