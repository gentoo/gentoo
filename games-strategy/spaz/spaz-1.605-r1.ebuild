# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit desktop eutils unpacker

DESCRIPTION="Space Pirates and Zombies"
HOMEPAGE="http://minmax-games.com/SpacePiratesAndZombies/"
SRC_URI="${PN}-linux-humblebundle-09182012-bin"
LICENSE="LOKI-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="alsa pulseaudio"
RESTRICT="bindist fetch strip"

DEPEND=""
BDEPEND="app-arch/unzip"
RDEPEND="
	>=media-libs/openal-1.15.1[alsa?,pulseaudio?,abi_x86_32(-)]
	>=media-libs/libsdl-1.2.15-r4[abi_x86_32(-)]
"

S="${WORKDIR}"/data

QA_PREBUILT="opt/spaz/SPAZ"

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	local dir="/opt/${PN}"

	insinto "${dir}"
	exeinto "${dir}"
	doexe SPAZ
	doins -r common game mods
	doins audio.so
	newicon SPAZ.png spaz.png
	dodoc README-linux.txt

	make_wrapper ${PN} ./SPAZ "${dir}" "${dir}"
	make_desktop_entry ${PN} "Space Pirates and Zombies" ${PN}
}
