#!/bin/bash

set -eux

PV=$1
PN=xbmc
P="${PN}-${PV}"
DISTDIR="/usr/portage/distfiles"
GITDIR="/usr/local/src/xbmc/git"

if [[ ${PV} != "9999" ]] ; then
	rm -rf ${PN}-*/
	tar xf ${DISTDIR}/${P}.tar.gz
	d=$(echo ${PN}-*/)
else
	stamp=$(date --date="$(git log -n1 --pretty=format:%ci master)" -u +%Y%m%d)
	P+="-${stamp}"
	cd ${GITDIR}
	d=.
fi
make -C ${d} -j -f codegenerator.mk
tar="${DISTDIR}/${P}-generated-addons.tar.xz"
tar cf - ${d}/xbmc/interfaces/python/generated/*.cpp | xz > "${tar}"
if [[ ${PV} != "9999" ]] ; then
	rm -rf ${PN}-*/
fi

du -b "${tar}"
