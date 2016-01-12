# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games

IUSE=""
DESCRIPTION="Community Bonus Pack for UT2003"
HOMEPAGE="http://liandri.beyondunreal.com/Unreal_Tournament_2003"
SRC_URI="https://ut.rushbase.net/beyondunreal/mods/cbp2003.zip"

LICENSE="ut2003"
SLOT="1"
KEYWORDS="x86"
RESTRICT="mirror strip"

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
	for i in Animations Help Music Maps StaticMeshes Textures System
	do
		mkdir -p "${Ddir}"/${i} || die
	done
	games_umod_unpack CBP2003.ut2mod
	rm "${Ddir}/Readme.txt" "${Ddir}/cbp installer logo1.bmp"
	prepgamesdirs
}
