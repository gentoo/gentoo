# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs multilib

DESCRIPTION="xcalib is a tiny monitor calibration loader for X.org"
HOMEPAGE="http://xcalib.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-source-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXxf86vm"

DEPEND="${RDEPEND}
	x11-proto/xf86vidmodeproto"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-ldflags.patch"
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		XINCLUDEDIR=/usr/include \
		XLIBDIR=/usr/$(get_libdir) \
		|| die 'make failed'
}

src_install() {
	dobin xcalib
	dodoc README

	docinto profiles
	dodoc *.icm *.icc
}
