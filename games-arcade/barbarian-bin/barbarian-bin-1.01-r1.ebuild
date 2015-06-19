# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-arcade/barbarian-bin/barbarian-bin-1.01-r1.ebuild,v 1.5 2015/06/01 21:43:44 mr_bones_ Exp $

EAPI=5
inherit eutils games

MY_PN=${PN/-bin/}
DESCRIPTION="Save Princess Mariana through one-on-one battles with demonic barbarians"
HOMEPAGE="http://www.tdbsoft.com/"
SRC_URI="http://www.pcpages.com/tomberrr/downloads/${MY_PN}${PV/./}_linux.zip"

LICENSE="CC-BY-NC-ND-2.0"
SLOT="0"
KEYWORDS="-* amd64 x86"
RESTRICT="strip"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="sys-libs/libstdc++-v3:5
	amd64? ( sys-libs/libstdc++-v3:5[multilib] )
	>=media-libs/libsdl-1.2.15-r4[abi_x86_32(-)]"

game_dest="${GAMES_PREFIX_OPT}/${MY_PN}"
QA_PREBUILT="${game_dest:1}/Barbarian"

S=${WORKDIR}

src_install() {
	dodir "${game_dest}"
	cp -r gfx sounds "${D}${game_dest}/" || die

	exeinto "${game_dest}"
	doexe Barbarian

	dohtml Barbarian.html

	games_make_wrapper barbarian ./Barbarian "${game_dest}"

	# High-score file
	dodir "${GAMES_STATEDIR}"
	touch "${D}${GAMES_STATEDIR}/heroes.hoh"
	fperms 660 "${GAMES_STATEDIR}/heroes.hoh"
	dosym "${GAMES_STATEDIR}/heroes.hoh" "${game_dest}/heroes.hoh"
	newicon gfx/sprites/player_attack_2_1.bmp barbarian.bmp
	make_desktop_entry barbarian "Barbarian" /usr/share/pixmaps/barbarian.bmp
	prepgamesdirs
}
