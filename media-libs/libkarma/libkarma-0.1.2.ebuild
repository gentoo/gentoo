# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libkarma/libkarma-0.1.2.ebuild,v 1.4 2012/08/18 12:29:53 xmw Exp $

EAPI="4"
inherit eutils mono toolchain-funcs

DESCRIPTION="Support library for using Rio devices with mtp"
HOMEPAGE="http://www.freakysoft.de/libkarma/"
SRC_URI="http://www.freakysoft.de/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="virtual/libiconv
	media-libs/taglib
	dev-lang/mono
	virtual/libusb:0"
DEPEND="${RDEPEND}"

MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	# Make this respect LDFLAGS, bug #336151
	epatch "${FILESDIR}"/${PN}-0.1.0-ldflags.patch
}

src_compile() {
	tc-export AR CC RANLIB
	emake all
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc THANKS TODO
	mono_multilib_comply
}
