# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit games

MY_P="debonus.ut2mod.zip"
DESCRIPTION="Digital Extremes Bonus Pack for UT2003"
HOMEPAGE="https://www.moddb.com/games/unreal-tournament-2003"
SRC_URI="http://ftp.student.utwente.nl/pub/games/UT2003/BonusPack/${MY_P}"

LICENSE="ut2003"
SLOT="1"
KEYWORDS="~x86"
IUSE=""
RESTRICT="bindist mirror strip"

RDEPEND="games-fps/ut2003"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

dir=${GAMES_PREFIX_OPT}/ut2003
Ddir=${D}/${dir}

src_unpack() {
	unzip -qq "${DISTDIR}"/${A} || die
}

src_install() {
	mkdir -p "${Ddir}"/{System,Maps,StaticMeshes,Textures,Music,Help} || die
	games_umod_unpack DEBonus.ut2mod
	prepgamesdirs
}
