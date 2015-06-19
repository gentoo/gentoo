#!/bin/bash
#
# This script was adapted from the one used by Hwaci to build it's 
# documentation and binaries for shipping to their website. 
#
# Any similarity to the original has probably been trampled into
# oblivion modifying everything for Gentoo.
#
echo "Starting TCL Build"

# Set srcdir to the name of the directory that contains the publish.sh
# script.
#
srcdir=`echo "$0" | sed 's%\(^.*\)/[^/][^/]*$%\1%'`

#
# Build the tclsqlite.so shared library for import into tclsh or wish
# under Linux
#
make target_source
source /etc/make.conf
cd tsrc
rm shell.c

OPTS='-DUSE_TCL_STUBS=1 -DNDEBUG=1'
TCLSTUBLIB=${TCL_BUILD_STUB_LIB_PATH}

export CFLAGS
gcc -fPIC $CFLAGS $OPTS -I. -shared *.c $TCLSTUBLIB -o tclsqlite.so

strip tclsqlite.so
cp tclsqlite.so ..

cd ..

echo "pkg_mkIndex [pwd] tclsqlite.so" >> make_pkgIndex.tcl
tclsh make_pkgIndex.tcl

echo "Done TCL Build"

