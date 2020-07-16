# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Curses-based clone of the nifty little Macintosh freeware game Galaxis"
HOMEPAGE="http://www.catb.org/~esr/galaxis/"
SRC_URI="http://www.catb.org/~esr/galaxis/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.3:0="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_compile() {
	local PKGCONFIG="$(tc-getPKG_CONFIG)"
	emake TERMLIB="$(${PKGCONFIG} --libs ncurses)"
}

src_install() {
	dobin galaxis
	doman galaxis.6
	einstalldocs
}
