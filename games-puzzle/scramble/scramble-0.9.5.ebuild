# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/scramble/scramble-0.9.5.ebuild,v 1.4 2015/02/07 13:29:58 ago Exp $

EAPI=5
inherit autotools flag-o-matic games

DESCRIPTION="Create as many words as you can before the time runs out"
HOMEPAGE="http://www.shiftygames.com/scramble/scramble.html"
SRC_URI="http://www.shiftygames.com/scramble/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND=">=media-libs/libsdl-1.2[sound,video]
	>=media-libs/sdl-mixer-1.2[vorbis]
	>=media-libs/sdl-image-1.2[png]
	media-libs/sdl-ttf"
RDEPEND="${DEPEND}
	sys-apps/miscfiles"

src_prepare() {
	append-cflags $(sdl-config --cflags)
	eautoreconf
}

src_install() {
	default
	prepgamesdirs
}
