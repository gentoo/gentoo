# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit base toolchain-funcs

DESCRIPTION="ncurses based analog clock"
HOMEPAGE="https://soomka.com/clockywock"
SRC_URI="https://soomka.com/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-makefile.patch" )

src_prepare() {
	# Respect compiler
	tc-export CXX

	base_src_prepare
}

src_install() {
	dobin ${PN}
	doman ${PN}.7
	dodoc README CREDITS
}
