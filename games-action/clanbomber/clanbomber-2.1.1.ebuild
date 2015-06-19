# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/clanbomber/clanbomber-2.1.1.ebuild,v 1.10 2015/02/06 13:44:04 ago Exp $

EAPI=5
inherit autotools eutils games

DESCRIPTION="Bomberman-like multiplayer game"
HOMEPAGE="http://savannah.nongnu.org/projects/clanbomber/"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/${P}.tar.lzma"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="media-libs/libsdl[sound,joystick,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer
	media-libs/sdl-ttf
	media-libs/sdl-gfx
	dev-libs/boost
	media-fonts/dejavu"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog ChangeLog.hg IDEAS NEWS QUOTES README TODO )

src_prepare() {
	sed -i -e 's/menuentry//' src/Makefile.am || die
	epatch \
		"${FILESDIR}"/${P}-automake112.patch \
		"${FILESDIR}"/${P}-boost150.patch
	eautoreconf
}

src_install() {
	default
	newicon src/pics/cup2.png ${PN}.png
	make_desktop_entry ${PN}2 ClanBomber2
	rm -f "${D}${GAMES_DATADIR}"/${PN}/fonts/DejaVuSans-Bold.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSans-Bold.ttf \
		"${GAMES_DATADIR}"/${PN}/fonts/DejaVuSans-Bold.ttf
	prepgamesdirs
}
