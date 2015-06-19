#!/bin/bash
# Generate the various interface files that normally requires java.
# This makes building the release versions much nicer.

set -eux

PV=$1
PN=kodi
P="${PN}-${PV}"
DISTDIR="/usr/portage/distfiles"
GITDIR="/usr/local/src/kodi/git"

if [[ ${PV} != "9999" ]] ; then
	rm -rf xbmc-*/
	tar xf ${DISTDIR}/${P}.tar.gz
	d=$(echo xbmc-*/)
else
	stamp=$(date --date="$(git log -n1 --pretty=format:%ci master)" -u +%Y%m%d)
	P+="-${stamp}"
	cd ${GITDIR}
	d=.
fi
#cd ${d} && git init . && git add . && git commit -qmm && cd ..
make -C ${d} -j -f codegenerator.mk
tar="${DISTDIR}/${P}-generated-addons.tar.xz"
tar cf - \
	${d}/xbmc/interfaces/python/generated/*.cpp \
	${d}/xbmc/interfaces/json-rpc/ServiceDescription.h \
	| xz > "${tar}"
if [[ ${PV} != "9999" ]] ; then
	rm -rf xbmc-*/
fi

du -b "${tar}"
