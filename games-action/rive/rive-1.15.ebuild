# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker xdg

DESCRIPTION="Metal wrecking, robot hacking 360-degree shooter/platformer hybrid"
HOMEPAGE="https://rivethegame.com/"
SRC_URI="${PN^^}-Linux-2017-02-28.sh"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist fetch splitdebug"

RDEPEND="
	media-libs/libsdl2[opengl,video]
	media-libs/openal
"

S="${WORKDIR}/data"

DIR="/opt/${PN}"
QA_PREBUILT="${DIR#/}/*"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  https://www.humblebundle.com/store/${PN}"
	einfo "and move it to your distfiles directory."
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	exeinto "${DIR}"
	newexe x86_64/${PN^^}.bin.x86_64 ${PN^^}.bin
	dosym "../..${DIR}"/${PN^^}.bin /usr/bin/${PN}

	insinto "${DIR}"
	doins -r noarch/*

	newicon -s 256 noarch/app_icon.png ${PN}.png
	make_desktop_entry ${PN} ${PN^^}
}
