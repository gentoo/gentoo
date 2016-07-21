#!/bin/bash

# Create a virtualbox modules tarball from a VirtualBox binary package.
# We cannot download the package by this script because of the unpredictable 
# build number being in the filename.
# 
# usage: create_vbox_modules_tarball.sh VirtualBox-4.1.18-78361-Linux_amd64.run

[ -f "$1" ] || exit 1

VBOX_PACKAGE="$1"
VERSION_SUFFIX=""

if [[ ${VBOX_PACKAGE} = *_BETA* ]] || [[ ${VBOX_PACKAGE} = *_RC* ]] ; then
	VERSION_SUFFIX="$(echo ${VBOX_PACKAGE} | sed 's@.*VirtualBox-[[:digit:]\.]\+\(_[[:alpha:]]\+[[:digit:]]\).*@\L\1@')"
	
fi

VBOX_VER="$(echo ${VBOX_PACKAGE} | sed 's@.*VirtualBox-\([[:digit:]\.]\+\).*@\1@')${VERSION_SUFFIX}"


sh ${VBOX_PACKAGE} --noexec --keep --nox11 || exit 2
cd install || exit 3
tar -xaf VirtualBox.tar.bz2 || exit 4
cd src/vboxhost || exit 5
tar -cvJf ../../../vbox-kernel-module-src-${VBOX_VER}.tar.xz . || exit 6
cd ../../.. && rm install -rf

exit 0
