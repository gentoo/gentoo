# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/gnurobbo/gnurobbo-0.66.ebuild,v 1.7 2015/02/20 20:43:58 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="Robbo, a popular Atari XE/XL game ported to Linux"
HOMEPAGE="http://gnurobbo.sourceforge.net/"
SRC_URI="mirror://sourceforge/gnurobbo/${P}-source.tar.gz"

LICENSE="GPL-2 BitstreamVera"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/libsdl[sound,video,joystick]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-underlink.patch )

src_compile() {
	emake \
		PACKAGE_DATA_DIR="${GAMES_DATADIR}/${PN}" \
		BINDIR="${GAMES_BINDIR}" \
		DOCDIR="/usr/share/doc/${PF}"
}

src_install() {
	dogamesbin gnurobbo
	insinto "${GAMES_DATADIR}/${PN}"
	doins -r data/{levels,skins,locales,rob,sounds}
	dodoc AUTHORS Bugs ChangeLog README TODO
	newicon icon32.png ${PN}.png
	make_desktop_entry ${PN} Gnurobbo
	prepgamesdirs
}
