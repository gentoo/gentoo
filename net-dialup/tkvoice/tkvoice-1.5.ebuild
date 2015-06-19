# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/tkvoice/tkvoice-1.5.ebuild,v 1.4 2012/09/05 08:05:53 jlec Exp $

EAPI=4

inherit eutils

DESCRIPTION="Voice mail and Fax frontend program"
HOMEPAGE="http://tkvoice.netfirms.com"
SRC_URI="http://tkvoice.netfirms.com/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="
	dev-lang/tk
	media-libs/netpbm
	media-sound/sox
	net-dialup/mgetty"
DEPEND="${DEPEND}"

src_prepare() {
	sed -i -e "s:/usr/local/etc:/etc:g; s:/usr/local/bin:/usr/bin:g; s:/usr/local/tkvoice:/usr/lib/${P}:g" \
		"${S}/tkvoice" "${S}/TCL/tkvfaq.tcl" "${S}/TCL/tkvsetupvoice.tcl" || die
	sed -i -e "s:set STARTDIR .*:set STARTDIR /usr/lib/${P}:" \
		"${S}/tkvoice" || die
}

src_install() {
	exeinto /usr/lib/${P}
	doexe ${PN}
	dodir /usr/bin
	dosym /usr/lib/${P}/${PN} /usr/bin/${PN}
	insinto /usr/lib/${P}/TCL
	doins TCL/*
	insinto /usr/lib/${P}/image
	doins image/*

	domenu "${FILESDIR}/${PN}.desktop"
	insinto /usr/share/pixmaps
	doins ${PN}.xpm

	dodoc BUGS FAQ README TODO
}

pkg_postinst() {
	elog "${P} has been installed. Run ${EPREFIX}/usr/bin/${PN}."
	elog "For more information, see the home page, ${HOMEPAGE}"
	elog "or consult the documentation for this program as well as"
	elog "for mgetty/vgetty."
}
