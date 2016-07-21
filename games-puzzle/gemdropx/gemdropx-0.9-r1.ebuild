# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games

DESCRIPTION="A puzzle game where it's your job to clear the screen of gems"
HOMEPAGE="http://www.newbreedsoftware.com/gemdropx/"
SRC_URI="ftp://ftp.sonic.net/pub/users/nbs/unix/x/gemdropx/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=">=media-libs/libsdl-1.2.3-r1[joystick,video]
	>=media-libs/sdl-mixer-1.2.1[mod]"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e '/^CC/d' \
		-e '/^CXX/d' \
		-e 's/CXX/CC/' \
		-e 's/-o/$(LDFLAGS) -o/' \
		Makefile || die

	find data/ -type d -name .xvpics -exec rm -rf \{\} +
}

src_compile() {
	emake \
		DATA_PREFIX="${GAMES_DATADIR}/${PN}" \
		XTRA_FLAGS="${CFLAGS}"
}

src_install() {
	dogamesbin gemdropx
	dodir "${GAMES_DATADIR}/${PN}"
	cp -r data/* "${D}/${GAMES_DATADIR}/${PN}/" || die
	dodoc AUTHORS.txt CHANGES.txt ICON.txt README.txt TODO.txt
	prepgamesdirs
}
