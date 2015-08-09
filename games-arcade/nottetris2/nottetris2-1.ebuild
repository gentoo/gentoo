# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils games

DESCRIPTION="The spiritual successor of the classic Tetris mixed with physics"
HOMEPAGE="http://stabyourself.net/nottetris2/"
SRC_URI="http://stabyourself.net/dl.php?file=nottetris2/nottetris2-linux.zip -> ${P}.zip"

LICENSE="CC-BY-NC-SA-3.0"
SLOT="0"
KEYWORDS="amd64 x86"

LVSLOT="0.7"
RDEPEND=">=games-engines/love-0.7.2:${LVSLOT}
	 media-libs/devil[png]"
DEPEND="app-arch/unzip"

S=${WORKDIR}

src_install() {
	local dir=${GAMES_DATADIR}/love/${PN}

	exeinto "${dir}"
	newexe "Not Tetris 2.love" ${PN}.love

	newdoc "Not Readme.txt" README

	games_make_wrapper ${PN} "love-${LVSLOT} ${PN}.love" "${dir}"
	make_desktop_entry ${PN}

	prepgamesdirs
}
