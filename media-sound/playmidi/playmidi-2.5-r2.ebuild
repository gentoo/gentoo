# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="Command Line and GUI based MIDI Player"
HOMEPAGE="http://sourceforge.net/projects/playmidi/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE="svga X"

RDEPEND="sys-libs/ncurses
	svga? ( media-libs/svgalib )
	X? ( x11-libs/libX11
		x11-libs/libSM
		x11-libs/libXaw )"
DEPEND="${RDEPEND}
	X? ( x11-proto/xextproto )"

S="${WORKDIR}/${P/2.5/2.4}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}.patch
	epatch "${FILESDIR}"/CAN-2005-0020.patch
	epatch "${FILESDIR}"/${P}-includes.patch
}

src_compile() {
	local targets="playmidi"

	use svga && targets="$targets splaymidi"
	use X && targets="$targets xplaymidi"

	echo "5" | ./Configure

	emake -j1 CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
		depend clean || die "emake failed."
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} -I." LDFLAGS="${LDFLAGS}" ${targets} \
		|| die "emake failed."
}

src_install() {
	dobin playmidi
	use svga && dobin splaymidi
	use X && dobin xplaymidi
	dodoc BUGS QuickStart README.1ST
	docinto techref
	dodoc techref/*
}
