# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="ASCII art editor"
HOMEPAGE="https://www.cs.helsinki.fi/u/penberg/duhdraw"
SRC_URI="https://www.cs.helsinki.fi/u/penberg/duhdraw/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-macos.patch
	"${FILESDIR}"/${P}-prestrip.patch
)

src_compile() {
	emake \
		CC="$(tc-getCC) ${CFLAGS} ${LDFLAGS}" \
		LIBS="$($(tc-getPKG_CONFIG) --libs ncurses)"
}

src_install() {
	dobin ansi ansitoc duhdraw
	dodoc CREDITS HISTORY TODO
}
