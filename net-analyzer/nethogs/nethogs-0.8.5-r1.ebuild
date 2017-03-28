# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A small 'net top' tool, grouping bandwidth by process"
HOMEPAGE="https://github.com/raboof/nethogs"
SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~x86"

RDEPEND="
	net-libs/libpcap
	sys-libs/ncurses:0=
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_compile() {
	tc-export CC CXX
	emake NCURSES_LIBS="$( $(tc-getPKG_CONFIG) --libs ncurses )" ${PN}
}

src_install() {
	emake DESTDIR="${ED}" PREFIX="/usr" install
	dodoc Changelog DESIGN README.decpcap.txt README.md
}
