# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/exult-sound/exult-sound-0.ebuild,v 1.4 2015/02/10 10:12:57 ago Exp $

EAPI=5
inherit games

DESCRIPTION="sound data for games-engines/exult"
HOMEPAGE="http://exult.sourceforge.net/"
SRC_URI="mirror://sourceforge/exult/U7MusicOGG_1of2.zip
	mirror://sourceforge/exult/U7MusicOGG_2of2.zip
	mirror://sourceforge/exult/jmsfx.zip
	mirror://sourceforge/exult/jmsfxsi.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="!<games-engines/exult-9999"

S=${WORKDIR}

src_unpack() {
	mkdir music && cd music || die
	unpack U7MusicOGG_{1,2}of2.zip
	cd "${WORKDIR}" || die
	mkdir flx && cd flx || die
	unpack jmsfx{,si}.zip
}

src_install() {
	insinto "${GAMES_DATADIR}/exult/music"
	doins "${WORKDIR}/music/"*ogg
	insinto "${GAMES_DATADIR}/exult/"
	doins "${WORKDIR}/flx/"*.flx
	newdoc "${WORKDIR}/music/readme.txt" music-readme.txt
	prepgamesdirs
}
