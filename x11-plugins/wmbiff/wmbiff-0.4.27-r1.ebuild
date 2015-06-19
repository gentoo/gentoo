# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmbiff/wmbiff-0.4.27-r1.ebuild,v 1.7 2014/08/12 00:08:20 blueness Exp $

EAPI=4
inherit autotools eutils

DESCRIPTION="WMBiff is a dock applet for WindowMaker which can monitor up to 5 mailboxes"
HOMEPAGE="http://sourceforge.net/projects/wmbiff/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=" amd64 ppc x86"
IUSE="crypt"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	crypt? (
		>=dev-libs/libgcrypt-1.2.1:0
		>=net-libs/gnutls-1.2.3
		)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/xextproto
	x11-proto/xproto"

DOCS="ChangeLog FAQ NEWS README README.licq TODO wmbiff/sample.wmbiffrc"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gnutls.patch
	epatch "${FILESDIR}"/${P}-gnutls-3.patch
	epatch "${FILESDIR}"/${P}-invalid-strncpy.patch
	sed -i -e '/AC_PATH_XTRA_CORRECTED/d' configure.ac || die
	sed -i -e '/pkg.*SCRIPTS/s:pkglib:pkgdata:' scripts/Makefile.am || die #421411
	eautoreconf
}

src_configure() {
	econf $(use_enable crypt crypto)
}
