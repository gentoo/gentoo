# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="ext2fs and minix disk editor for linux"
HOMEPAGE="http://lde.sourceforge.net/"
SRC_URI="mirror://sourceforge/lde/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-libs/ncurses:0="
DEPEND="
	${RDEPEND}
	dev-util/yacc"

S="${WORKDIR}/${PN}"

PATCHES=(
	"${FILESDIR}/${P}-no-shadowing.patch"
)

DOCS=( WARNING README TODO COPYING )

RESTRICT="test"

src_install() {
	dosbin "${PN}"
	newman "doc/${PN}.man" "${PN}.8"
	einstalldocs
}
