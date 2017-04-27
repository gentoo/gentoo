# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="CPU statistics monitor utility for X Windows"
SRC_URI="http://www.tigr.net/afterstep/download/ascpu/${P}.tar.gz"
HOMEPAGE="http://www.tigr.net/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~mips ppc ppc64 sparc x86"
IUSE="jpeg"

RDEPEND="x11-libs/libXpm
	x11-libs/libSM
	jpeg? ( virtual/jpeg:0 )"

DEPEND="${RDEPEND}
	x11-proto/xproto"

PATCHES=( "${FILESDIR}/${P}-gentoo-r1.patch" )

src_configure() {
	econf $(use_enable jpeg)
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dodir /usr/bin
	dodir /usr/share/man/man1
	dodoc README
	default
}
