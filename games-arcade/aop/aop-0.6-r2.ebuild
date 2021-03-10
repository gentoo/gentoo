# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Ambassador of Pain is a curses based game with only 64 lines of code"
HOMEPAGE="http://raffi.at/view/code/aop"
SRC_URI="http://www.raffi.at/code/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND="sys-libs/ncurses:0"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-as-needed.patch
)

src_prepare() {
	default

	sed -i \
		-e "s#/usr/local/share#/usr/share/${PN}#" \
		aop.c || die
}

src_install() {
	dobin aop

	insinto "/usr/share/${PN}"
	doins aop-level-*.txt

	einstalldocs
}
