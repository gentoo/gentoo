# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-1.99pl2"

inherit toolchain-funcs

DESCRIPTION="A curses-based file manager"
HOMEPAGE="http://www.han.de/~werner/ytree.html"
SRC_URI="http://www.han.de/~werner/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="virtual/pkgconfig"
DEPEND="
	sys-libs/ncurses:0=
	sys-libs/readline:0=
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${PN}-1.94-bindir.patch"
	"${FILESDIR}/${PN}-1.99-tinfo.patch"
)

DOCS=( CHANGES README THANKS ytree.conf )

pkg_setup() {
	tc-export CC
}

src_install() {
	einstalldocs
	dobin ${PN}
	doman ${PN}.1
}
