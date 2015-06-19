# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/icebreaker/icebreaker-1.9.6.ebuild,v 1.6 2015/01/28 10:24:38 ago Exp $

EAPI=5
inherit eutils games

DESCRIPTION="Trap and capture penguins on Antarctica"
HOMEPAGE="http://www.mattdm.org/icebreaker/"
SRC_URI="http://www.mattdm.org/${PN}/1.9.x/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="media-libs/libsdl[video]
	media-libs/sdl-mixer"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-ldflags.patch \
		"${FILESDIR}"/${P}-gentoo.patch \
		"${FILESDIR}"/${P}-parallell-install.patch \
		"${FILESDIR}"/${P}-ovfl.patch
}

src_compile() {
	emake \
		OPTIMIZE="${CFLAGS}" \
		prefix=/usr \
		bindir="${GAMES_BINDIR}" \
		datadir="${GAMES_DATADIR}" \
		highscoredir="${GAMES_STATEDIR}"
}

src_install() {
	emake \
		prefix="${D}/usr" \
		bindir="${D}${GAMES_BINDIR}" \
		datadir="${D}${GAMES_DATADIR}" \
		highscoredir="${D}${GAMES_STATEDIR}" install
	newicon ${PN}_48.bmp ${PN}.bmp
	make_desktop_entry ${PN} IceBreaker /usr/share/pixmaps/${PN}.bmp
	dodoc ChangeLog README* TODO
	prepgamesdirs
}
