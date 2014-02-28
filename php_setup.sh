#!/bin/bash
package="php-5.5.9.tar.gz"
conf_file_path="/usr/local/lib/"

if [ ! -f $package ]; then
    wget -O $package http://www.php.net/get/$package/from/this/mirror
    tar -xzvf $package
fi

#get essential libs

for testpackage in libxml2-dev libbz2-dev libmcrypt-dev php5-mysqlnd
do
    dpkg --status $testpackage  2>&1 >/dev/null | grep -q "not installed"
    if [ $? -eq 0 ]; then
        echo "Installing $testpackage..."
        sudo apt-get install -y $testpackage
    fi
done;

cd php-5*
make distclean
./configure \
    --with-apxs2=/usr/local/apache2/bin/apxs \
    --enable-mysqlnd --with-mysqli=mysqlnd \
    --with-bz2 --with-zlib --enable-zip --enable-mbstring --with-mcrypt \
    --with-config-file-path==$conf_file_path \
    | tee mk_configure.log
make | tee mk_build.log && sudo make install
if [ $? -eq 0 ]; then
    sudo cp php.ini-development $conf_file_path/php.ini
    make distclean
    echo "PHP5 is installed successfully!"
    cd .. && rm -rf php-5*
else
    echo "[ERROR] PHP5 install failed!"
    exit 2
fi

ext_path="$conf_file_path/php/extensions/no-debug-zts-20121212"
for file in mysqli.so mysqlnd.so
do
    if [ ! -f "$ext_path/$file" ]
    then
        sudo cp "/usr/lib/php5/20090626/$file" "$ext_path"
    fi
done

