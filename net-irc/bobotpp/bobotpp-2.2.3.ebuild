# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/bobotpp/bobotpp-2.2.3.ebuild,v 1.4 2012/02/06 17:23:33 ranger Exp $

EAPI=4

inherit autotools autotools-utils eutils

DESCRIPTION="A flexible IRC bot scriptable in scheme"
HOMEPAGE="http://unknownlamer.org/code/bobot.html"
SRC_URI="http://savannah.nongnu.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="guile"

DEPEND="guile? ( dev-scheme/guile )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.2.2-asneeded.patch \
		"${FILESDIR}"/${P}-stdout.patch
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-crypt
		$(use_enable guile scripting)
	)

	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	dosym bobot++.info /usr/share/info/bobotpp.info

	dodoc AUTHORS ChangeLog NEWS README TODO
	dohtml documentation/index.html

	docinto examples/config
	dodoc examples/config/*

	docinto examples/scripts
	dodoc examples/scripts/*
}

pkg_postinst() {
	elog "You can find a sample configuration file set in"
	elog "${EPREFIX}/usr/share/doc/${PF}/example-config"
}
