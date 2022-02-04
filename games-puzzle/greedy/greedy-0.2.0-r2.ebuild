# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="fun little ncurses puzzle game"
HOMEPAGE="http://www.kotinet.com/juhamattin/linux/index.html"
SRC_URI="http://www.kotinet.com/juhamattin/linux/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-missing-include.patch )

src_prepare() {
	default

	rm Makefile || die
	# It wants a scores file.  We need to touch one and install it.
	touch greedy.scores || die
}

src_compile() {
	emake CC="$(tc-getCC)" LDLIBS="$($(tc-getPKG_CONFIG) ncurses --libs)" greedy
}

src_install() {
	dobin greedy
	einstalldocs

	insinto /var/games
	doins greedy.scores
	# We need to set the permissions correctly
	fperms 664 /var/games/greedy.scores
}
