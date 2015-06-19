# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/moon-buggy/moon-buggy-1.0.51.ebuild,v 1.8 2014/11/19 06:50:10 mr_bones_ Exp $

EAPI=5
inherit autotools eutils games

DESCRIPTION="A simple console game, where you drive a car across the moon's surface"
HOMEPAGE="http://www.seehuhn.de/comp/moon-buggy.html"
SRC_URI="http://www.seehuhn.de/data/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc x86"
IUSE=""

RDEPEND="sys-libs/ncurses"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	sed -i \
		-e '/$(DESTDIR)$(bindir)\/moon-buggy -c/d' \
		Makefile.am || die
	rm -f missing
	eautoreconf
}

src_configure() {
	egamesconf \
		--sharedstatedir="${GAMES_STATEDIR}" \
		--with-curses-libs="$(pkg-config ncurses --libs)"
}

src_install() {
	default
	touch "${D}${GAMES_STATEDIR}"/${PN}/mbscore
	fperms 664 "${GAMES_STATEDIR}"/${PN}/mbscore
	prepgamesdirs
}
