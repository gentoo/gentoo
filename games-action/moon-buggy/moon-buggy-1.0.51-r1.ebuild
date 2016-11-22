# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils user

DESCRIPTION="A simple console game, where you drive a car across the moon's surface"
HOMEPAGE="http://www.seehuhn.de/comp/moon-buggy.html"
SRC_URI="http://www.seehuhn.de/data/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"
IUSE=""

RDEPEND="sys-libs/ncurses:0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

pkg_setup(){
	enewgroup gamestat 36
}

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
