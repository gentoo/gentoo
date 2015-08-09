# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit games

DESCRIPTION="ascii mode unreal tournament"
HOMEPAGE="http://icculus.org/~chunky/ut/aaut/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND="|| (
		games-fps/unreal-tournament
		games-fps/unreal-tournament-goty )
	media-libs/aalib"

src_install() {
	dogamesbin "${FILESDIR}/aaut" || die "dogamesbin failed"
	prepgamesdirs
}
