# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit games

MY_P="debonus.ut2mod.zip"
DESCRIPTION="Digital Extremes Bonus Pack for UT2003"
HOMEPAGE="http://www.unrealtournament2003.com/"
SRC_URI="mirror://3dgamers/unrealtourn2/Missions/${MY_P}
	http://www.unixforces.net/downloads/${MY_P}"

LICENSE="ut2003"
SLOT="1"
KEYWORDS="x86"
IUSE=""
RESTRICT="mirror strip"

DEPEND="app-arch/unzip"
RDEPEND="games-fps/ut2003"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/ut2003
Ddir=${D}/${dir}

src_unpack() {
	unzip -qq "${DISTDIR}"/${A} || die "unpacking"
}

src_install() {
	mkdir -p "${Ddir}"/{System,Maps,StaticMeshes,Textures,Music,Help}
	games_umod_unpack DEBonus.ut2mod
	prepgamesdirs
}
