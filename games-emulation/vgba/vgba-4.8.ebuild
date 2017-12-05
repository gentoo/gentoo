# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit games

DESCRIPTION="Gameboy Advance (GBA) emulator for Linux"
HOMEPAGE="http://www.komkon.org/fms/VGBA/"
SRC_URI="http://fms.komkon.org/VGBA/VGBA${PV/.}-Linux-Ubuntu-bin.tgz"

LICENSE="VGBA"
SLOT="0"
KEYWORDS="-* ~x86"
RESTRICT="strip"
IUSE=""

RDEPEND="x11-libs/libXext
	sys-libs/zlib"

QA_PREBUILT="${GAMES_PREFIX_OPT:1}/bin/vgba"

S=${WORKDIR}

src_install() {
	into "${GAMES_PREFIX_OPT}"
	dobin vgba
	dohtml VGBA.html
	prepgamesdirs
}
