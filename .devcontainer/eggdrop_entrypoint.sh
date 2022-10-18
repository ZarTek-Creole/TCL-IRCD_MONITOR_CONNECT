#!/bin/bash
set -e
echo "CHargement de eggdrop_entrypoint.sh"

if [[ ! -f /usr/lib/tcltk/x86_64-linux-gnu/libmysqltcl3.052.so ]]
then
    apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community tcl-lib tcl-tls mysql-dev
    apk add --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community gcc git libc-dev make tcl-dev
    git clone https://github.com/xdobry/mysqltcl.git mysqltcl
    cd mysqltcl
    ./configure
    make
    make install
    mkdir -p /usr/lib/tcltk/x86_64-linux-gnu
    cp /usr/lib/mysqltcl-3.05/libmysqltcl3.05.so /usr/lib/tcltk/x86_64-linux-gnu
    echo "package ifneeded mysqltcl 3.052 [list load [file join $dir libmysqltcl3.052.so] mysqltcl]" > /usr/lib/tcltk/x86_64-linux-gnu/pkgIndex.tcl
    cd ..
    rm -rf mysqltcl
    apk del gcc git libc-dev make tcl-dev
fi
/home/eggdrop/eggdrop/entrypoint.sh IMC.conf