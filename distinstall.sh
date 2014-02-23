#!/bin/bash

##instal vim

#git vim sources
git submodule init

#get essential libs

for testpackage in "libncurses5-dev" "libx11-dev" "libxtst-dev" libxt-dev \
                    libsm-dev libxpm-dev
do
    dpkg --status $testpackage  2>&1 >/dev/null | grep -q "not installed"
    if [ $? -eq 0 ]; then
        echo "Installing $testpackage..."
        sudo apt-get install -y $testpackage
    fi
done;

cd vim
make distclean
./configure \
    --with-features=huge \
    --with-x
make && sudo make install
