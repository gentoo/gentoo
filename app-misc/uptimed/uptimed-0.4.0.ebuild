# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/uptimed/uptimed-0.4.0.ebuild,v 1.1 2015/04/17 11:42:00 polynomial-c Exp $

EAPI=5

inherit autotools eutils user systemd

DESCRIPTION="System uptime record daemon that keeps track of your highest uptimes"
HOMEPAGE="https://github.com/rpodgorny/uptimed/"
SRC_URI="https://github.com/rpodgorny/uptimed/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="static-libs"

pkg_setup() {
	enewgroup uptimed
	enewuser uptimed -1 -1 -1 uptimed
}

src_prepare() {
	# respect DESTDIR
	sed -i -e 's|-d \(/var/spool.*\)$|-d $(DESTDIR)\1|' Makefile.am || die
	# fix configure.ac for >=automake-1.13 (bug #467582)
	sed 's@AM_CONFIG_HEADER@AC_CONFIG_HEADERS@' -i configure.ac || die
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files --all
	keepdir /var/spool/uptimed
	fowners uptimed:uptimed /var/spool/uptimed
	dodoc ChangeLog README.md TODO AUTHORS CREDITS INSTALL.cgi sample-cgi/*
	newinitd "${FILESDIR}"/${PN}.init uptimed
	systemd_dounit "${FILESDIR}/${PN}.service"
}

pkg_postinst() {
	einfo "Fixing permissions in /var/spool/${PN}"
	chown -R uptimed:uptimed /var/spool/${PN}
	echo
	elog "Start uptimed with '/etc/init.d/uptimed start' (for openRC)"
	elog "or systemctl start uptimed (for systemd)"
	elog "To view your uptime records, use the command 'uprecords'."
	echo
}
