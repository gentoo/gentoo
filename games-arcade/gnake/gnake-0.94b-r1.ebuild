# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="An ncurses-based Nibbles clone"
HOMEPAGE="http://lightless.org/gnake"
SRC_URI="mirror://gentoo/Gnake.${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/ncurses:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

S="${WORKDIR}/${PN}"

src_compile() {
	emake LDLIBS="$($(tc-getPKG_CONFIG) ncurses --libs)" gnake
}

src_install() {
	dobin gnake
	einstalldocs
}
