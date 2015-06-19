# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/spaz/spaz-1.605.ebuild,v 1.5 2015/06/14 17:19:45 ulm Exp $

EAPI=4

inherit unpacker games

DESCRIPTION="Space Pirates and Zombies"
HOMEPAGE="http://spacepiratesandzombies.com"
SRC_URI="${PN}-linux-humblebundle-09182012-bin"
LICENSE="LOKI-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="alsa pulseaudio"
RESTRICT="fetch strip"

DEPEND="app-arch/unzip"
RDEPEND=">=media-libs/openal-1.15.1[alsa?,pulseaudio?,abi_x86_32(-)]
	>=media-libs/libsdl-1.2.15-r4[abi_x86_32(-)]"

S="${WORKDIR}"/data

QA_PREBUILT="opt/spaz/SPAZ"

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"

	insinto "${dir}"
	exeinto "${dir}"
	doexe SPAZ
	doins -r common game mods
	doins audio.so
	newicon SPAZ.png spaz.png
	dodoc README-linux.txt

	games_make_wrapper ${PN} ./SPAZ "${dir}" "${dir}"
	make_desktop_entry ${PN} "Space Pirates and Zombies" ${PN}

	prepgamesdirs
}
