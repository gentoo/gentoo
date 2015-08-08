# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="Small but powerful library implementing the client-server IRC protocol"
HOMEPAGE="http://www.ulduzsoft.com/libircclient/"
SRC_URI="mirror://sourceforge/libircclient/${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc ipv6 ssl static-libs threads"

DEPEND="ssl? ( dev-libs/openssl:0 )"
RDEPEND=${DEPEND}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-shared.patch \
		"${FILESDIR}"/${P}-static.patch \
		"${FILESDIR}"/${P}-include.patch
	mv configure.in configure.ac || die
	eautoconf
}

src_configure() {
	econf \
		$(use_enable threads) \
		$(use_enable ipv6) \
		$(use_enable ssl openssl) \
		$(use_enable ssl threads)
}

src_compile() {
	emake -C src $(usex static-libs "shared static" "shared")
}

src_install() {
	emake -C src DESTDIR="${D}" install-shared $(usex static-libs "install-static" "")
	insinto /usr/include/libircclient
	doins include/*.h

	dodoc Changelog THANKS
	doman man/libircclient.1
}
