# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="ncurses based analog clock"
HOMEPAGE="https://soomka.com/clockywock"
SRC_URI="https://soomka.com/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}/${P}-makefile.patch" )

src_prepare() {
	# Respect compiler
	tc-export CXX

	default_src_prepare
}

src_install() {
	dobin ${PN}
	doman ${PN}.7
	dodoc README CREDITS
}
