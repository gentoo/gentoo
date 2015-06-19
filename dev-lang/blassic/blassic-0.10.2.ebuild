# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/blassic/blassic-0.10.2.ebuild,v 1.10 2015/02/06 13:42:34 ago Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="classic Basic interpreter"
HOMEPAGE="http://blassic.org"
SRC_URI="http://blassic.org/bin/${P}.tgz"

LICENSE="GPL-2"
KEYWORDS="amd64 hppa ppc x86 ~x86-linux ~ppc-macos ~x86-macos"
SLOT="0"
IUSE="X"

RDEPEND="sys-libs/ncurses
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
