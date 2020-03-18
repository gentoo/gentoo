# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Ambassador of Pain is a curses based game with only 64 lines of code"
HOMEPAGE="http://raffi.at/view/code/aop"
SRC_URI="http://www.raffi.at/code/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

RDEPEND="sys-libs/ncurses:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
	sed -i \
		-e "s#/usr/local/share#${GAMES_DATADIR}#" \
		aop.c || die
	eapply "${FILESDIR}"/${P}-as-needed.patch
}

src_install() {
	dobin aop
	insinto "/usr/shate/${PN}"
	doins aop-level-*.txt
	einstalldocs
}
