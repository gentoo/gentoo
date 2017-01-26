#!/bin/bash

DISTDIR="$(portageq envvar DISTDIR 2>/dev/null)"
DISTDIR="${DISTDIR:-/usr/portage/distfiles}"
if [[ ! -d "${DISTDIR}" ]] ; then
	echo "No DISTDIR found."
	exit 1
fi

PN=debugedit

gentoo_functions="/lib/gentoo/functions.sh"
if [[ -f "${gentoo_functions}" ]] ; then
	. "${gentoo_functions}"
else
	echo "Failed to source ${gentoo_functions} file."
	echo "Please install sys-apps/gentoo-functions package."
	exit 1
fi

set -e

einfo "Getting updated index"
rm -f index.html
wget -q http://rpm5.org/

PV=$(sed -n '/Production:/{n;s:.*RPM ::;s:<.*::;p;q}' index.html)
einfo "Latest upstream version: ${PV}"
rm -f index.html

P="${PN}-${PV}"
A=${P}.tar.bz2

e=${P}.ebuild
if [[ -e ../${e} ]] ; then
	einfo "All up to date"
	exit 0
fi

#tf=${DISTDIR}/${A}
#if [[ ! -e ${tf} ]] ; then
#	einfo "Cannot find ${tf}"
#	exit 0
#fi

einfo "Fetching latest rpm tarball"
r=rpm-${PV}
wget -nv http://rpm5.org/files/rpm/rpm-${PV%.*}/${r}.tar.gz -P ${DISTDIR} -c

einfo "Unpacking ${r}"
rm -rf ${r}
tar xf ${DISTDIR}/${r}.tar.gz

einfo "Creating ${P}"
rm -rf ${P}
mkdir ${P}
cp Makefile ${r}/tools/{hashtab.?,debugedit.c} ${P}/
pushd ${P} >/dev/null
more=true
while ${more} ; do
	more=false
	for h in $(grep '#include' *.[ch] | awk '{print $NF}' | sed 's:[<>"]::g') ; do
		[[ ${h} == */* ]] && continue
		rh=$(find ../${r} -name ${h##*/})
		if [[ -n ${rh} ]] && [[ ! -e ${rh##*/} ]] ; then
			# don't copy glibc includes
			if ! grep -qs 'This file is part of the GNU C Library' ${rh} ; then
				cp ${rh} ./
				more=true
			fi
		fi
	done
done
popd >/dev/null
tar jcf ${A} ${P}

einfo "Testing build"
pushd ${P} >/dev/null
make -s
popd >/dev/null

einfo "Cleaning up"
rm -rf ${P} ${r}
du -b ${A}
