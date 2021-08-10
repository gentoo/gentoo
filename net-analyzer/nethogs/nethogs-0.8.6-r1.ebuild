# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fcaps toolchain-funcs

DESCRIPTION="A small 'net top' tool, grouping bandwidth by process"
HOMEPAGE="https://github.com/raboof/nethogs"
SRC_URI="https://github.com/raboof/nethogs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 x86"

DOCS=( DESIGN README.decpcap.txt README.md )

RDEPEND="
	net-libs/libpcap
	sys-libs/ncurses:0=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

FILECAPS=(
	cap_net_admin,cap_net_raw usr/sbin/nethogs
)

src_compile() {
	tc-export CC CXX
	emake NCURSES_LIBS="$( $(tc-getPKG_CONFIG) --libs ncurses )" "${PN}"
}

src_install() {
	emake DESTDIR="${ED}" PREFIX="/usr" install
	einstalldocs
}
