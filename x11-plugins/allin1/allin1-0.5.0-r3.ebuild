# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="All in one monitoring dockapp: RAM, CPU, Net, Power, df, seti"
HOMEPAGE="http://ilpettegolo.altervista.org/linux_allin1.en.shtml"
SRC_URI="mirror://sourceforge/allinone/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="app-alternatives/lex"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_configure() {
	tc-export CC
}

src_install() {
	dobin src/allin1
	doman docs/allin1.1
	dodoc README README.it TODO ChangeLog BUGS src/allin1.conf.example
}
