# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="Console Minesweeper"
HOMEPAGE="https://github.com/rwestlund/freesweep"
SRC_URI="https://github.com/rwestlund/freesweep/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos"

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	sed -i -e "s:configure.in:configure.ac:" Makefile.in || die
	# Clang 16, bug #899002
	eautoreconf
}

src_compile() {
	emake LIBS="$($(tc-getPKG_CONFIG) --libs ncurses || die)"
}

src_install() {
	dobin freesweep
	doman freesweep.6
	einstalldocs
}
