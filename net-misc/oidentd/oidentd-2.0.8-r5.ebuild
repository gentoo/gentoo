# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils systemd

DESCRIPTION="Another (RFC1413 compliant) ident daemon"
HOMEPAGE="http://ojnk.sourceforge.net/"
SRC_URI="mirror://sourceforge/ojnk/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="debug ipv6 masquerade"

src_prepare() {
	epatch "${FILESDIR}/${P}-masquerading.patch" \
		"${FILESDIR}/${P}-bind-to-ipv6-too.patch" \
		"${FILESDIR}/${P}-gcc5.patch"
}

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable ipv6) \
		$(use_enable masquerade masq) \
		$(use_enable masquerade nat)
}

src_install() {
	default

	dodoc AUTHORS ChangeLog README TODO NEWS \
		"${FILESDIR}"/${PN}_masq.conf "${FILESDIR}"/${PN}.conf

	newinitd "${FILESDIR}"/${PN}-2.0.7-init ${PN}
	newconfd "${FILESDIR}"/${PN}-2.0.7-confd ${PN}

	systemd_newunit "${FILESDIR}"/${PN}_at.service ${PN}@.service
	systemd_dounit "${FILESDIR}"/${PN}.socket
	systemd_dounit "${FILESDIR}"/${PN}.service
}

pkg_postinst() {
	echo
	elog "Example configuration files are in /usr/share/doc/${PF}"
	echo
}
