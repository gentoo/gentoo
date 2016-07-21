# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games

DESCRIPTION="Futuristic FPS (bonus packs)"
HOMEPAGE="http://www.unrealtournament.com/"
# UT has 4 official bonus packs ...
# [UTBonusPack]  -> loki put into games-fps/unreal-tournament
# [UTBonusPack2] -> loki put into games-fps/unreal-tournament
# [UTiNoxxPack]  -> loki put into games-fps/unreal-tournament
# [UTBonusPack4] -> none of this is in games-fps/unreal-tournament
SRC_URI="http://fpsnetwork.com/downloads/ut99/bonuspacks/UTBonusPack4.zip"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="mirror bindist"

RDEPEND="|| (
	games-fps/unreal-tournament
	games-fps/unreal-tournament-goty )"
DEPEND="${RDEPEND}
	app-arch/unzip
	games-util/umodpack"

S=${WORKDIR}

src_install() {
	# unpack the UTBonusPack4 umod
	umod -v -b "$(pwd)" -x UTBonusPack4.umod || die

	# move stuff around
	rm UTBonusPack4.umod
	mv system System
	mv textures Textures

	# install it all
	local dir=${GAMES_PREFIX_OPT}/unreal-tournament
	dodir "${dir}"
	mv * "${D}/${dir}/"

	prepgamesdirs
}
