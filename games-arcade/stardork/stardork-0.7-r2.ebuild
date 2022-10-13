# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="ncurses-based space shooter"
HOMEPAGE="https://stardork.sourceforge.net/"
SRC_URI="mirror://sourceforge/stardork/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND="sys-libs/ncurses:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-clang16.patch
)

src_compile() {
	tc-export CC
	append-cppflags $($(tc-getPKG_CONFIG) ncurses --cflags || die)
	append-libs $($(tc-getPKG_CONFIG) ncurses --libs || die)

	emake -f /dev/null LDLIBS="${LIBS}" ${PN}
}

src_install() {
	dobin ${PN}
	einstalldocs
}
