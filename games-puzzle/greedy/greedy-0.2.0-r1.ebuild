# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs games

DESCRIPTION="fun little ncurses puzzle game"
HOMEPAGE="http://www.kotinet.com/juhamattin/linux/index.html"
SRC_URI="http://www.kotinet.com/juhamattin/linux/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE=""

RDEPEND="sys-libs/ncurses:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	rm -f Makefile
	# It wants a scores file.  We need to touch one and install it.
	touch greedy.scores
}

src_compile() {
	emake CC="$(tc-getCC)" LDLIBS="$($(tc-getPKG_CONFIG) ncurses --libs)" ${PN}
}

src_install() {
	insinto "${GAMES_STATEDIR}"
	doins greedy.scores

	dogamesbin greedy
	dodoc CHANGES README TODO

	prepgamesdirs
	# We need to set the permissions correctly
	fperms 664 "${GAMES_STATEDIR}/greedy.scores"
}
