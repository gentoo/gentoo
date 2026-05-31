# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${PN}_${PV}
inherit toolchain-funcs

DESCRIPTION="ncurses-based hex-editor with diff mode"
HOMEPAGE="https://www.dettus.net/dhex/"
SRC_URI="https://www.dettus.net/${PN}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~riscv ~x86"

DEPEND="sys-libs/ncurses:="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-Makefile.patch
	"${FILESDIR}"/${P}-initcolors-prototype.patch
)

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LIBS="$($(tc-getPKG_CONFIG) --libs ncurses)"
}

src_install() {
	dobin dhex
	dodoc README.txt
	doman dhex.1 dhex_markers.5 dhex_searchlog.5 dhexrc.5
}
