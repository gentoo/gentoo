# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Console Minesweeper"
HOMEPAGE="https://github.com/rwestlund/freesweep"
SRC_URI="http://www.upl.cs.wisc.edu/~hartmann/sweep/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_compile() {
	emake LIBS="$( $(tc-getPKG_CONFIG) --libs ncurses)"
}

src_install() {
	dobin freesweep
	einstalldocs
	doman freesweep.6
}
