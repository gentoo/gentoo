# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop wrapper xdg

MY_PN="BffOrDie"
DESCRIPTION="Time travelling alien couch co-op puzzle game for 1-4 players"
HOMEPAGE="https://www.bffordie.com/"
SRC_URI="${MY_PN}_Linux.zip"
S="${WORKDIR}/${MY_PN}_Linux"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch splitdebug"

RDEPEND="
	sys-libs/zlib
	virtual/opengl
"
BDEPEND="
	app-arch/unzip
"

DIR="/opt/${PN}"
QA_PREBUILT="${DIR#/}/*"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  https://asa-studio.itch.io/${PN}"
	einfo "and move it to your distfiles directory."
}

src_install() {
	exeinto "${DIR}"
	newexe ${MY_PN}.$(usex amd64 x86_64 x86) ${MY_PN}
	make_wrapper ${PN} "${DIR}"/${MY_PN}

	insinto "${DIR}"
	doins -r ${MY_PN}_Data/
	rm -r "${ED}/${DIR}"/${MY_PN}_Data/*/$(usex amd64 x86 x86_64) || die

	# Some Unity games have a GUI launcher but this one doesn't use it.
	rm "${ED}/${DIR}"/${MY_PN}_Data/Plugins/*/ScreenSelector.so || die

	newicon -s 128 ${MY_PN}_Data/Resources/UnityPlayer.png ${PN}.png
	make_desktop_entry ${PN} "BFF or Die"
}
