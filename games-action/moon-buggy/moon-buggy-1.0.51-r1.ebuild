# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils

DESCRIPTION="A simple console game, where you drive a car across the moon's surface"
HOMEPAGE="https://www.seehuhn.de/pages/moon-buggy.html"
SRC_URI="https://m.seehuhn.de/programs/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="acct-group/gamestat
	sys-libs/ncurses:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
	sed -i \
		-e '/$(DESTDIR)$(bindir)\/moon-buggy -c/d' \
		Makefile.am || die
	rm -f missing
	eautoreconf
}

src_configure() {
	econf \
		--sharedstatedir="/var/games" \
		--with-curses-libs="$(pkg-config ncurses --libs)"
}

src_install() {
	default
	touch "${D}/var/games/${PN}/mbscore"
	fowners root:gamestat /usr/bin/${PN} /var/games/${PN} /var/games/${PN}/mbscore
	fperms 2755 /usr/bin/${PN}
	fperms 664 /var/games/${PN}/mbscore
}
