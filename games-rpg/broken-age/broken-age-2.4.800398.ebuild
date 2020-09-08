# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils desktop xdg

MY_PN="BrokenAge"
DESCRIPTION="A point-and-click adventure from Tim Schafer's Double Fine Productions"
HOMEPAGE="http://www.brokenagegame.com"
SRC_URI="${MY_PN}_linux.tar.gz"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch splitdebug"

RDEPEND="
	media-libs/libsdl2[abi_x86_32,joystick,opengl,sound,video]
	virtual/opengl[abi_x86_32]
"

S="${WORKDIR}"

DIR="/opt/${PN}"
QA_PREBUILT="${DIR}/*"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  https://www.humblebundle.com/store/${PN}"
	einfo "and move it to your distfiles directory."
}

src_install() {
	exeinto "${DIR}"
	doexe ${MY_PN}
	make_wrapper ${PN} ./${MY_PN} "${DIR}"

	insinto "${DIR}"
	doins *.pck

	exeinto "${DIR}"/lib
	doexe lib/libfmod*.so

	make_desktop_entry ${PN} "Broken Age" applications-games
	dodoc ReadMe.txt
}
