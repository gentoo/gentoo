# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/wepdecrypt/wepdecrypt-0.8-r2.ebuild,v 1.1 2012/12/21 23:25:01 alonbl Exp $

EAPI=4

inherit eutils

DESCRIPTION="Enhanced version of WepAttack a tool for breaking 802.11 WEP keys"
HOMEPAGE="http://wepdecrypt.sourceforge.net/"
SRC_URI="mirror://sourceforge/wepdecrypt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="X"
RDEPEND="
	dev-libs/openssl
	net-libs/libpcap
	sys-libs/zlib
	X? ( x11-libs/fltk:1 )"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-fltk.patch

	#Fix buffer size wrt bug 340148.
	epatch "${FILESDIR}/${P}-buffer.patch"

	epatch "${FILESDIR}/${P}-dyn.patch"

	#Fix respect for jobserver
	sed -i 's/make/$(MAKE)/g' Makefile || die "Sed failed"
}

src_configure() {
	# build system is broken and --enabled-gui doesn't work
	local myconf=""
	! use X && myconf="--disable-gui"

	econf ${myconf}
}
