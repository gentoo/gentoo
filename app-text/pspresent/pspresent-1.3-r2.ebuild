# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A tool to display full-screen PostScript presentations"
HOMEPAGE="http://www.cse.unsw.edu.au/~matthewc/pspresent/"
SRC_URI="http://www.cse.unsw.edu.au/~matthewc/pspresent/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="xinerama"

RDEPEND="
	app-text/ghostscript-gpl
	x11-libs/libX11
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_configure() {
	tc-export CC PKG_CONFIG
	use xinerama && export USE_XINERAMA=1
}

src_install() {
	dobin pspresent
	doman pspresent.1
}
