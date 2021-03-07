# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="An ncurses-based Xenon clone"
HOMEPAGE="http://www.alessandropira.org/alienwave/aw.html"
SRC_URI="http://www.alessandropira.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/ncurses:0"
RDEPEND=${DEPEND}
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_compile() {
	emake LIB="$($(tc-getPKG_CONFIG) --libs ncurses)"
}

src_install() {
	dobin alienwave
	dodoc TO_DO README STORY
}
