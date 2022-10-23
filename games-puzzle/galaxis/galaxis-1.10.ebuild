# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop flag-o-matic toolchain-funcs

DESCRIPTION="Curses-based clone of the nifty little Macintosh freeware game Galaxis"
HOMEPAGE="http://www.catb.org/~esr/galaxis/"
SRC_URI="http://www.catb.org/~esr/galaxis/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

DEPEND="sys-libs/ncurses:="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-c2x.patch
)

src_compile() {
	append-cppflags $($(tc-getPKG_CONFIG) --cflags ncurses || die) -DNDEBUG
	append-libs $($(tc-getPKG_CONFIG) --libs ncurses || die)

	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} ${CPPFLAGS} ${LDFLAGS}" TERMLIB="${LIBS}"
}

src_install() {
	dobin ${PN}
	doman ${PN}.6
	einstalldocs

	doicon ${PN}.png
	domenu ${PN}.desktop
}
