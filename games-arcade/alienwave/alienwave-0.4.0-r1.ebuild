# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="An ncurses-based Xenon clone"
HOMEPAGE="http://www.alessandropira.org/alienwave/aw.html"
SRC_URI="http://www.alessandropira.org/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

DEPEND="sys-libs/ncurses:0"
RDEPEND=${DEPEND}

S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_install() {
	dobin alienwave
	dodoc TO_DO README STORY
}
