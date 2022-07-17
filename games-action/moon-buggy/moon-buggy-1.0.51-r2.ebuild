# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic toolchain-funcs

DESCRIPTION="Simple console game, where you drive a car across the moon's surface"
HOMEPAGE="https://www.seehuhn.de/pages/moon-buggy.html"
SRC_URI="https://m.seehuhn.de/programs/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="acct-group/gamestat
	sys-libs/ncurses:0="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	sed -i \
		-e '/$(DESTDIR)$(bindir)\/moon-buggy -c/d' \
		Makefile.am || die
	rm missing || die
	eautoreconf
}

src_configure() {
	# LTO warnings, bug #858518
	filter-lto

	econf \
		--sharedstatedir="${EPREFIX}/var/games" \
		--with-curses-libs="$($(tc-getPKG_CONFIG) ncurses --libs)"
}

src_install() {
	default

	touch "${ED}/var/games/${PN}/mbscore" || die
	fowners root:gamestat /usr/bin/${PN} /var/games/${PN} /var/games/${PN}/mbscore
	fperms 2755 /usr/bin/${PN}
	fperms 664 /var/games/${PN}/mbscore
}
