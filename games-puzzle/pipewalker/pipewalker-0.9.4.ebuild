# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/pipewalker/pipewalker-0.9.4.ebuild,v 1.5 2015/02/24 22:17:54 tupone Exp $

EAPI=5
inherit eutils flag-o-matic games

DESCRIPTION="Rotating pieces puzzle game"
HOMEPAGE="http://pipewalker.sourceforge.net/"
SRC_URI="mirror://sourceforge/pipewalker/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libsdl[opengl,video]
	virtual/opengl
	virtual/glu"
RDEPEND="${DEPEND}"

src_configure() {
	append-flags $(sdl-config --cflags)
	egamesconf \
		--datadir="${GAMES_DATADIR_BASE}"
}

src_install() {
	emake -C data DESTDIR="${D}" install
	dogamesbin src/${PN}
	doicon extra/${PN}.xpm
	make_desktop_entry ${PN} PipeWalker
	dodoc AUTHORS ChangeLog README
	prepgamesdirs
}
