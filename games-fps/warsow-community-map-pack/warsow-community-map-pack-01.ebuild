# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games

MY_P=${P//-/_}
# They have a typo in their filename:
MY_P=${MY_P/community/comunity}

DESCRIPTION="Community Map Pack for the Warsow multiplayer FPS"
HOMEPAGE="http://www.warsow.net/"
SRC_URI="http://update.warsow.net/mirror/${MY_P}.zip"

LICENSE="freedist"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}

src_install() {
	insinto "${GAMES_DATADIR}"/warsow
	doins -r "${WORKDIR}"/{basewsw,previews}
	dodoc "${WORKDIR}"/Readme.rtf
	prepgamesdirs
}
