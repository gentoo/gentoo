# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils desktop unpacker xdg

MY_PN="SlimeRancher"
MY_P="${P//[-.]/_}"
MY_P="${MY_P//_p/_}"

DESCRIPTION="Cute game where you cultivate slimes on a distant planet"
HOMEPAGE="http://www.slimerancher.com/"
SRC_URI="${MY_P}.sh"
LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist fetch splitdebug"

RDEPEND="
	sys-libs/glibc
	virtual/opengl
"

BDEPEND="app-arch/unzip"

S="${WORKDIR}/data/noarch/game"

DIR="/opt/${PN}"
QA_PREBUILT="${DIR}/*"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  https://www.gog.com/game/${PN//-/_}"
	einfo "and move it to your distfiles directory."
}

src_unpack() {
	unpack_zip ${A}
}

src_prepare() {
	default

	# Some Unity games have a GUI launcher but this one doesn't use it.
	rm ${MY_PN}_Data/Plugins/x86_64/ScreenSelector.so || die
}

src_install() {
	exeinto "${DIR}"
	newexe ${MY_PN}.x86_64 ${MY_PN}
	make_wrapper ${PN} "${DIR}"/${MY_PN}

	insinto "${DIR}"
	doins -r ${MY_PN}_Data/

	newicon -s 128 ${MY_PN}_Data/Resources/UnityPlayer.png ${PN}.png
	make_desktop_entry ${PN} "Slime Rancher"
}
