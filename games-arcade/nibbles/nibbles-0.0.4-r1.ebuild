# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${PN}-v${PV}"
DESCRIPTION="An ncurses-based Nibbles clone"
HOMEPAGE="http://www.earth.li/projectpurple/progs/nibbles.html"
SRC_URI="http://www.earth.li/projectpurple/files/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

GAMES_DATADIR="/usr/share"
GAMES_STATEDIR="/var/games/${PN}"

PATCHES=(
	"${FILESDIR}"/${P}-as-needed.patch
)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	sed -i \
		-e "s#/usr/local/games/nibbles.levels#${GAMES_DATADIR}/${PN}#" \
		nibbles.h || die

	sed -i \
		-e "s#/var/lib/games/nibbles.score#${GAMES_STATEDIR}/nibbles.scores#" \
		scoring.h || die
}

src_compile() {
	PKGCONFIG="$(tc-getPKG_CONFIG)" emake
}

src_install() {
	dobin nibbles

	insinto "${GAMES_DATADIR}/${PN}"
	doins nibbles.levels/*

	dodir "${GAMES_STATEDIR}"
	touch "${ED}${GAMES_STATEDIR}/nibbles.scores"

	dodoc HISTORY CREDITS TODO README

	fperms 664 "${GAMES_STATEDIR}/nibbles.scores"
}
