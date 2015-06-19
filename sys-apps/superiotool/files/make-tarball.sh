#!/bin/bash

. /etc/init.d/functions.sh

svnrev() { svn info "$1" | awk '$1 == "Revision:" { print $NF }'; }

PN=superiotool
SVN_ROOT=${2:-/usr/local/src}
srcdir=${SVN_ROOT}/${PN}
PV=${1:-$(svnrev "${srcdir}")}

P=${PN}-${PV}
T=/tmp

if [[ -d ${srcdir} ]] ; then
	cd "${T}" || die

	rm -rf ${P}

	ebegin "Exporting ${srcdir} ${PV} to ${P}"
	svn export -q -r ${PV} ${srcdir} ${P}
	eend $? || die

	ebegin "Creating ${P}.tar.xz"
	tar cf - ${P} | xz > ${P}.tar.xz
	eend $?

	einfo "Tarball now ready at: ${T}/${P}.tar.xz"
else
	einfo "You need to run:"
	einfo " cd ${base}"
	einfo " svn co svn://coreboot.org/coreboot/trunk/util/superiotool"
	die "need svn checkout dir"
fi
