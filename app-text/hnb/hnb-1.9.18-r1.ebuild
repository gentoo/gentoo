# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A program to organize many kinds of data in one place"
HOMEPAGE="http://hnb.sourceforge.net/"
SRC_URI="http://hnb.sourceforge.net/.files/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-flags.patch
	"${FILESDIR}"/${P}-include.patch
	"${FILESDIR}"/${P}-printf.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default

	rm -r ${P} || die
	rm src/cli_history.o || die

	tc-export AR CC PKG_CONFIG

	# bug #532552
	export LC_ALL=C
}

src_install() {
	dodoc README doc/hnbrc
	doman doc/hnb.1
	dobin src/hnb
}
