# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="ncurses based sudoku game"
HOMEPAGE="https://jubalh.github.io/nudoku"
SRC_URI="https://github.com/jubalh/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cairo"

DEPEND="
	cairo? ( x11-libs/cairo )
	sys-libs/ncurses:=
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.1.0-ncurses-link.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable cairo)
}
