# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="WMaker DockApp: Slightly modified version of Jamie Zawinski's xmatrix screenhack"
HOMEPAGE="https://www.dockapps.net/wmmatrix"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

CDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${CDEPEND}
	x11-base/xorg-proto"
RDEPEND="${CDEPEND}
	x11-misc/xscreensaver"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-fno-common.patch
	)

src_compile() {
	# this version is distributed with compiled binaries!
	make clean
	emake CC="$(tc-getCC)" LIBDIR="/usr/$(get_libdir)"
}
