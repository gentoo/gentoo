# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit multilib rpm

MY_P="Nessus-${PV}-es6"
# We are using the Red Hat/CentOS binary

DESCRIPTION="A remote security scanner for Linux"
HOMEPAGE="http://www.nessus.org/"
SRC_URI="
	x86? ( ${MY_P}.i686.rpm )
	amd64? ( ${MY_P}.x86_64.rpm )"

RESTRICT="mirror fetch strip"

LICENSE="GPL-2 Nessus-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="X"

pkg_nofetch() {
		einfo "Please download ${A} from ${HOMEPAGE}/download"
		einfo "The archive should then be placed into ${DISTDIR}."
}

src_install() {
	cp -pPR "${WORKDIR}"/opt "${D}"/

	# make sure these directories do not vanish
	# nessus will not run properly without them
	keepdir /opt/nessus/etc/nessus
	keepdir /opt/nessus/var/nessus/jobs
	keepdir /opt/nessus/var/nessus/logs
	keepdir /opt/nessus/var/nessus/tmp
	keepdir /opt/nessus/var/nessus/users

	# add PATH and MANPATH for convenience
	doenvd "${FILESDIR}"/90nessus-bin

	# init script
	newinitd "${FILESDIR}"/nessusd-initd nessusd-bin
	dosym libssl.so /usr/$(get_libdir)/libssl.so.10
	dosym libcrypto.so /usr/$(get_libdir)/libcrypto.so.10
}

pkg_postinst() {
	elog "You can get started running the following commands:"
	elog "/opt/nessus/sbin/nessus-adduser"
	elog "/opt/nessus/sbin/nessus-mkcert"
	elog "/opt/nessus/bin/nessus-fetch --register <your registration code>"
	elog "/etc/init.d/nessusd-bin start"
	elog
	elog "If you had a previous version of Nessus installed, use"
	elog "the following command to update the plugin database:"
	elog "/opt/nessus/sbin/nessusd -R"
	elog
	elog "For more information about nessus, please visit"
	elog "${HOMEPAGE}/documentation/"
}
