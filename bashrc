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
