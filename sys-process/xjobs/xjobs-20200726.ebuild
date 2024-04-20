# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Reads commands line by line and executes them in parallel"
HOMEPAGE="https://www.maier-komor.de/xjobs.html"
SRC_URI="https://www.maier-komor.de/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

BDEPEND="app-alternatives/lex"

# The ncurses/terminfo libraries are used to provide color and status
# support; but, they're detected and enabled automagically by the build
# system. Thus it would do no good to hide them behind a USE flag that
# can't be turned off.
DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/xjobs-20200726-command-v.patch"
	"${FILESDIR}/xjobs-20200726-dont-page-tests.patch"
)

src_install() {
	default
	use examples && dodoc -r examples
}
