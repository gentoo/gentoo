# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="classic Basic interpreter"
HOMEPAGE="http://blassic.net"
SRC_URI="http://blassic.net/bin/${P}.tgz"

LICENSE="GPL-2+"
KEYWORDS="amd64 hppa ppc x86 ~x86-linux ~ppc-macos ~x86-macos"
SLOT="0"
IUSE="X"

RDEPEND="sys-libs/ncurses:0
	X? ( x11-libs/libICE x11-libs/libX11 x11-libs/libSM )"
DEPEND="${RDEPEND}
	X? ( x11-proto/xproto )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-tinfo.patch
	eautoreconf
}

src_configure() {
	econf \
		--disable-svgalib \
		$(use_with X x)
}

DOCS=( AUTHORS NEWS README THANKS TODO )
