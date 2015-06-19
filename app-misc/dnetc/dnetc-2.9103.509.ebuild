# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/dnetc/dnetc-2.9103.509.ebuild,v 1.7 2014/01/02 00:06:44 robbat2 Exp $

EAPI=2
inherit user

MAJ_PV=${PV:0:6}
MIN_PV=${PV:7:9}

DESCRIPTION="distributed.net client"
HOMEPAGE="http://www.distributed.net"
SRC_URI="x86? ( http://http.distributed.net/pub/dcti/v${MAJ_PV}/dnetc${MIN_PV}-linux-x86-elf-uclibc.tar.gz )
	amd64? ( http://http.distributed.net/pub/dcti/v${MAJ_PV}/dnetc${MIN_PV}-linux-amd64-elf.tar.gz )"

LICENSE="distributed.net GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND=""
RDEPEND="net-dns/bind-tools"

QA_PRESTRIPPED="opt/distributed.net/dnetc"

S=${WORKDIR}/dnetc

src_prepare() {
	if use amd64; then
		mv dnetc${MIN_PV}-linux-amd64-elf dnetc
	elif use x86; then
		mv dnetc${MIN_PV}-linux-x86-elf-uclibc dnetc
	fi
}

src_install() {
	exeinto /opt/distributed.net
	doexe dnetc

	doman dnetc.1
	dodoc docs/CHANGES.txt docs/dnetc.txt docs/readme.*

	newinitd "${FILESDIR}"/dnetc.initd dnetc
	newconfd "${FILESDIR}"/dnetc.confd dnetc

	keepdir /var/spool/dnetc
}

pkg_preinst() {
	if [ -e /opt/distributed.net/dnetc ] && [ -e /etc/init.d/dnetc ]; then
		einfo "flushing old buffers"
		source /etc/conf.d/dnetc

		if [ -e /opt/distributed.net/dnetc.ini ]; then
			# use ini file
			/opt/distributed.net/dnetc -quiet -ini /opt/distributed.net/dnetc.ini -flush
		elif [ ! -e /opt/distributed.net/dnetc.ini ] && [ ! -z ${EMAIL} ]; then
			# email adress from config
			/opt/distributed.net/dnetc -quiet -flush -e ${EMAIL}
		fi

		einfo "removing old buffer files"
		rm -f /opt/distributed.net/buff*
	fi

	enewgroup dnetc
	enewuser dnetc -1 -1 /opt/distributed.net dnetc
}

pkg_postinst() {
	chown -Rf dnetc:dnetc /opt/distributed.net
	chmod 0555 /opt/distributed.net/dnetc

	elog "To run distributed.net client in the background at boot:"
	elog "   rc-update add dnetc default"
	elog ""
	elog "Either configure your email address in /etc/conf.d/dnetc"
	elog "or create the configuration file /opt/distributed.net/dnetc.ini"
}

pkg_postrm() {
	if [ -d /opt/distributed.net ]; then
		elog "All files has not been removed from /opt/distributed.net"
	fi
}
