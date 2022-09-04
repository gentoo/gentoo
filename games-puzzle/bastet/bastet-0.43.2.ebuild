# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="a simple, evil, ncurses-based Tetris(R) clone"
HOMEPAGE="http://fph.altervista.org/prog/bastet.shtml"
SRC_URI="https://github.com/fph/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	sys-libs/ncurses:0=
	dev-libs/boost:=
"
RDEPEND="${DEPEND}"

BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.43.2-Makefile.patch
	"${FILESDIR}"/${P}-boost_include.patch
)

src_install() {
	dobin bastet
	doman bastet.6
	dodoc AUTHORS NEWS README
	dodir /var/games
	touch "${ED}/var/games/bastet.scores" || die "touch failed"
	fperms 664 /var/games/bastet.scores
}
