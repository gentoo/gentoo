# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/unreal-tournament-bonuspacks/unreal-tournament-bonuspacks-436.ebuild,v 1.10 2014/05/05 20:59:24 ulm Exp $

inherit games

DESCRIPTION="Futuristic FPS (bonus packs)"
HOMEPAGE="http://www.unrealtournament.com/"
# UT has 4 official bonus packs ...
# [UTBonusPack]  -> loki put into games-fps/unreal-tournament
# [UTBonusPack2] -> loki put into games-fps/unreal-tournament
# [UTiNoxxPack]  -> loki put into games-fps/unreal-tournament
# [UTBonusPack4] -> none of this is in games-fps/unreal-tournament
SRC_URI="http://fileserver.talkware.net/ut/bonuspacks/UTBonusPack4.zip
	http://www.dices.de/dices/files/UTBonusPack4.zip"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE=""
RESTRICT="mirror bindist"

DEPEND="app-arch/unzip
	|| (
		games-fps/unreal-tournament
		games-fps/unreal-tournament-goty )
	games-util/umodpack"
RDEPEND="|| (
	games-fps/unreal-tournament
	games-fps/unreal-tournament-goty )"

S=${WORKDIR}

src_install() {
	# unpack the UTBonusPack4 umod
	umod -v -b "$(pwd)" -x UTBonusPack4.umod || die "could not unpack UTBonusPack4.umod"

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
