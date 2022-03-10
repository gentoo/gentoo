# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="ncurses-based visual comparison of binary files"
HOMEPAGE="https://sourceforge.net/projects/hexcompare/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
)

src_configure() {
	tc-export CC PKG_CONFIG
	default
}

src_install() {
	dobin ${PN}
	dodoc README
}
