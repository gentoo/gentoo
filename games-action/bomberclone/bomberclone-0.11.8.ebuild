# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils autotools games

DESCRIPTION="BomberMan clone with network game support"
HOMEPAGE="http://www.bomberclone.de/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc ppc64 x86"
IUSE="X"

DEPEND=">=media-libs/libsdl-1.1.0
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[mod]
	X? ( x11-libs/libXt )"
RDEPEND="${DEPEND}"

src_prepare() {
	ecvs_clean
	epatch "${FILESDIR}"/${P}-underlink.patch
	eautoreconf
}

src_configure() {
	egamesconf \
		$(use_with X x) \
		--datadir="${GAMES_DATADIR_BASE}"
	sed -i \
		-e "/PACKAGE_DATA_DIR/ s:/usr/games/share/games/:${GAMES_DATADIR}/:" \
		config.h \
		|| die
}

src_install() {
	dogamesbin src/${PN}

	insinto "${GAMES_DATADIR}/${PN}"
	doins -r data/{gfx,maps,player,tileset,music}
	find "${D}" -name "Makefile*" -exec rm -f '{}' +

	dodoc AUTHORS ChangeLog README TODO
	doicon data/pixmaps/bomberclone.png
	make_desktop_entry bomberclone Bomberclone
	prepgamesdirs
}
