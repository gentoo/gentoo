# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit user versionator linux-info

MAJ_PV="$(get_major_version).$(get_version_component_range 2)"
MIN_PV="$(get_version_component_range 3)"

DESCRIPTION="distributed.net client"
HOMEPAGE="http://www.distributed.net"
SRC_URI="http://http.distributed.net/pub/dcti/v${MAJ_PV}/dnetc${MIN_PV}-linux-x86-elf-uclibc.tar.gz"

LICENSE="distributed.net GPL-2"
SLOT="0"
KEYWORDS="-* x86"
RESTRICT="mirror"

IUSE=""
DEPEND=""
RDEPEND=""

QA_PRESTRIPPED="opt/distributed.net/dnetc"

S="${WORKDIR}/dnetc${MIN_PV}-linux-x86-elf-uclibc"

pkg_setup() {
	local CONFIG_CHECK="~SYSVIPC"
	local WARNING_SYSVIPC="CONFIG_SYSVIPC:\tis not set (required for dnetc)"
	check_extra_config
	echo
}

pkg_preinst() {
	enewgroup dnetc
	enewuser dnetc -1 -1 /opt/distributed.net dnetc
	if [ -e /opt/distributed.net/dnetc ] && [ -e /etc/init.d/dnetc ]; then
		ebegin "Flushing old buffers"
		source /etc/conf.d/dnetc

		if [ -e /etc/init.d/dnetc ] ; then
			/etc/init.d/dnetc flush
			local flushed=${?}
		fi

		if [ ${flushed} -eq 0 ] ; then
			true
		elif [ -e /opt/distributed.net/dnetc.ini ]; then
			# use ini file
			/opt/distributed.net/dnetc -quiet -ini /opt/distributed.net/dnetc.ini -flush
		elif [ ! -e /opt/distributed.net/dnetc.ini ] && [ ! -z ${EMAIL} ]; then
			# email adress from config
			/opt/distributed.net/dnetc -quiet -flush -e ${EMAIL}
		fi

		eend ${?}
	fi
}

src_install() {
	newinitd "${FILESDIR}"/dnetc.initd dnetc
	newconfd "${FILESDIR}"/dnetc.confd dnetc

	local ownopts="--mode=0555 --group=dnetc --owner=dnetc"

	diropts ${ownopts}
	dodir /opt/distributed.net

	exeopts ${ownopts}
	exeinto /opt/distributed.net
	doexe dnetc

	doman dnetc.1
	dodoc docs/CHANGES.txt docs/dnetc.txt docs/readme.*

	diropts ${ownopts/0555/0755}
	dodir /var/spool/dnetc
}

pkg_postinst() {
	einfo "To run distributed.net client in the background at boot:"
	einfo "   rc-update add dnetc default"
	einfo
	einfo "Either configure your email address in /etc/conf.d/dnetc"
	einfo "or create the configuration file /opt/distributed.net/dnetc.ini"
}

pkg_postrm() {
	if [ -d /opt/distributed.net ]; then
		einfo "All files has not been removed from /opt/distributed.net"
		einfo "Probably old init file and/or buffer files"
	fi
}
