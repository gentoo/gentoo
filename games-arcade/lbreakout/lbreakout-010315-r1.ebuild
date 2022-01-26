# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="Breakout clone written with the SDL library"
HOMEPAGE="https://lgames.sourceforge.io/LBreakout/"
SRC_URI="
	mirror://sourceforge/lgames/${P}.tar.gz
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-group/gamestat
	media-libs/libsdl[sound,video]"
DEPEND="${RDEPEND}"

HTML_DOCS=( lbreakout/manual/. )

src_prepare() {
	default

	# remove /games from datadir, and use /var/games for highscore file
	sed -e '/^sdir=/s|/games.*||;' \
		-e "/^hdir=/s|=.*|=${EPREFIX}/var/games|" \
		-i configure || die

	tc-export CC CXX
}

src_install() {
	dodir /var/games #655000

	default

	fowners :gamestat /usr/bin/${PN} /var/games/${PN}.hscr
	fperms g+s /usr/bin/${PN}
	fperms 660 /var/games/${PN}.hscr

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} LBreakout
}
