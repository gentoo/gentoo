# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils games

DESCRIPTION="The classic word guessing game"
HOMEPAGE="http://www.shiftygames.com/hangman/hangman.html"
SRC_URI="http://www.shiftygames.com/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE=""

DEPEND="!games-misc/bsd-games
	media-libs/libsdl
	media-libs/sdl-mixer
	media-libs/sdl-image
	media-libs/sdl-ttf"
RDEPEND="${DEPEND}
	sys-apps/miscfiles"

src_prepare() {
	sed -i \
		-e 's/inline void SE_CheckEvents/void SE_CheckEvents/' \
		src/hangman.c \
		|| die "sed failed"
}

src_install() {
	default
	newicon pics/noose.png ${PN}.png
	make_desktop_entry ${PN} Hangman
	prepgamesdirs
}
