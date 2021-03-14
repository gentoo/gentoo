# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${PN}_${PV}
inherit toolchain-funcs

DESCRIPTION="ncurses-based hex-editor with diff mode"
HOMEPAGE="https://www.dettus.net/dhex/"
SRC_URI="https://www.dettus.net/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~x86"
IUSE=""

DEPEND="sys-libs/ncurses:="
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${P}-Makefile.patch )

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
