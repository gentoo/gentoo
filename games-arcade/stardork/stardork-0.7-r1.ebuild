# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="An ncurses-based space shooter"
HOMEPAGE="http://stardork.sourceforge.net/"
SRC_URI="mirror://sourceforge/stardork/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	default
	rm -f Makefile
}

src_compile() {
	emake CC="$(tc-getCC)" LDLIBS="$($(tc-getPKG_CONFIG) ncurses --libs)" ${PN}
}

src_install() {
	dobin ${PN}
	einstalldocs
}
