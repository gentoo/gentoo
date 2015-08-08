# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games

DESCRIPTION="Match rising tiles to score as many points as possible before the tiles touch the top of the board"
HOMEPAGE="http://www.shiftygames.com/torrent/torrent.html"
SRC_URI="http://www.shiftygames.com/torrent/${P}.tar.gz"

KEYWORDS="amd64 ppc x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=">=media-libs/libsdl-1.2.4
	>=media-libs/sdl-mixer-1.2
	>=media-libs/sdl-image-1.2
	media-libs/sdl-ttf"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e 's/inline void SE_CheckEvents/void SE_CheckEvents/' \
		src/torrent.c \
		|| die "sed failed"
}

src_install() {
	default
	prepgamesdirs
}
