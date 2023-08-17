# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A curses-based file manager"
HOMEPAGE="https://www.han.de/~werner/ytree.html"
SRC_URI="https://www.han.de/~werner/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

BDEPEND="virtual/pkgconfig"
DEPEND="
	sys-libs/ncurses:0=
	sys-libs/readline:0=
"
RDEPEND="${DEPEND}"

DOCS=( CHANGES README THANKS ytree.conf )

src_configure() {
	tc-export CC PKG_CONFIG

	default
}

src_install() {
	einstalldocs
	dobin ${PN}
	doman ${PN}.1
}
