# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# There's already a "hexedit" package in the tree, so name this one differently

EAPI=8

inherit autotools

MY_P=${P/curses-}
DESCRIPTION="full screen curses hex editor (with insert/delete support)"
HOMEPAGE="https://www.rogoyski.com/adam/programs/hexedit/"
SRC_URI="https://www.rogoyski.com/adam/programs/hexedit/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-ncurses-pkg-config.patch
	"${FILESDIR}"/${P}-ncurses-opaque.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --program-prefix=curses-
}
