# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils toolchain-funcs multilib

DESCRIPTION="WMaker DockApp: Slightly modified version of Jamie Zawinski's xmatrix screenhack"
HOMEPAGE="http://www.dockapps.net/wmmatrix"
SRC_URI="http://www.dockapps.net/download/${P}.tar.gz"

CDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${CDEPEND}
	x11-base/xorg-proto"
RDEPEND="${CDEPEND}
	x11-misc/xscreensaver"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-makefile.patch
}

src_compile() {
	# this version is distributed with compiled binaries!
	make clean
	emake CC="$(tc-getCC)" LIBDIR="/usr/$(get_libdir)" || die "compile failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "install failed"
}
