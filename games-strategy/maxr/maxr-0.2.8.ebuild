# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/maxr/maxr-0.2.8.ebuild,v 1.5 2015/03/28 21:22:34 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="Mechanized Assault and Exploration Reloaded"
HOMEPAGE="http://www.maxr.org/"
SRC_URI="http://www.maxr.org/downloads/${P}.tar.gz"

LICENSE="GPL-2 FDL-1.2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="media-libs/libsdl[video]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-net"
RDEPEND="${DEPEND}"

src_install() {
	dogamesbin src/${PN}
	insinto "${GAMES_DATADIR}"/${PN}
	doins -r data/*
	dodoc ABOUT CHANGELOG
	doicon data/maxr.png
	make_desktop_entry maxr "Mechanized Assault and Exploration Reloaded"
	prepgamesdirs
}
