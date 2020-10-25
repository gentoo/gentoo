#!/bin/bash

. /etc/init.d/functions.sh

PV=$1
SVN_ROOT=${2:-/usr/local/src}

if [[ $# -eq 0 ]] ; then
	ebegin "Detecting latest version"
	cd "${SVN_ROOT}/netpbm/release_number"
	svn up -q || die
	PV=$(svn ls | sort -V | tail -1) || die
	[[ -z ${PV} ]] && die
	PV=${PV%/}
	eend
	einfo "Using PV=${PV}"

	if [[ ! -d ${PV} ]] ; then
		ebegin "Checking out ${PV}"
		svn up -q ${PV}
		eend || die
	fi
fi

if [[ $# -gt 2 ]] ; then
	exec echo "Usage: $0 [version] [netpbm svn root]"
fi

PN=netpbm
P=${PN}-${PV}

T=/tmp

maint_pkg_create() {
	local base="/usr/local/src"
	local srcdir="${base}/netpbm/release_number"
	local htmldir="${base}/netpbm/userguide"
	if [[ -d ${srcdir} ]] ; then
		cd "${T}" || die

		rm -rf ${P}

		ebegin "Exporting ${srcdir}/${PV} to ${P}"
		svn export -q "${srcdir}/${PV}" ${P}
		eend $? || return 1

		ebegin "Exporting ${htmldir} to ${P}/userguide"
		svn export -q "${htmldir}" ${P}/userguide
		eend $? || return 1

		ebegin "Generating manpages from html"
		(cd "${P}/userguide" && ../buildtools/makeman *.html)
		eend $? || return 1

		ebegin "Creating ${P}.tar.xz"
		tar cf - ${P} | xz > ${P}.tar.xz
		eend $?

		einfo "Tarball now ready at: ${T}/${P}.tar.xz"
	else
		einfo "You need to run:"
		einfo " cd ${base}"
		einfo " svn co https://netpbm.svn.sourceforge.net/svnroot/netpbm"
		die "need svn checkout dir"
	fi
}
maint_pkg_create
