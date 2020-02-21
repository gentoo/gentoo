# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="ASCII space invaders clone"
HOMEPAGE="http://ninvaders.sourceforge.net/"
SRC_URI="mirror://sourceforge/ninvaders/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-compile.patch )

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LIBS="$($(tc-getPKG_CONFIG) --libs ncurses)"
}

src_install() {
	newbin nInvaders ninvaders
	einstalldocs
}
