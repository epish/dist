#!/bin/bash

#git httpd sources git://git.apache.org/httpd.git
#git httpd sources git://git.apache.org/apr-util.git
#git httpd sources git://git.apache.org/apr.git
git submodule update --init --recursive

#get essential libs

for testpackage in autoconf libtool libpcre3 libpcre3-dev
do
    dpkg --status $testpackage  2>&1 >/dev/null | grep -q "not installed"
    if [ $? -eq 0 ]; then
        echo "Installing $testpackage..."
        sudo apt-get install -y $testpackage
    fi
done;

cd httpd
./buildconf
make distclean
./configure \
    --enable-so
make && sudo make install clean
if [ $? -eq 0]; then
    make distclean
    echo "Apache httpd is installed successfully!"
else
    echo "[ERROR] Apache install failed!"
fi
