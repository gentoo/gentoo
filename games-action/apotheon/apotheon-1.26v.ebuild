# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker xdg-utils

DESCRIPTION="Heroic action game set within the vibrant world of Ancient Greek Mythology"
HOMEPAGE="https://www.apotheongame.com"
SRC_URI="${PN}-12302015-bin"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch splitdebug"

RDEPEND="
	dev-lang/mono
	media-libs/libsdl2[joystick,opengl,threads,video]
	media-libs/openal
	media-libs/sdl2-image
	media-libs/theoraplay
"

S="${WORKDIR}/data"

DIR="/opt/${PN}"
QA_PREBUILT="${DIR}/*"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  https://www.humblebundle.com/store/${PN}"
	einfo "and move it to your distfiles directory."
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	local \
		EXE=Apotheon.bin.$(usex amd64 x86_64 x86) \
		LIB=lib$(usex amd64 64 "")

	exeinto "${DIR}"
	doexe ${EXE}
	dosym "${DIR}"/${EXE} /usr/bin/${PN}

	insinto "${DIR}"
	doins -r Content/ Dialog/ *.exe [A-LP]*.dll* # Exclude some Mono DLLs.

	exeinto "${DIR}"/${LIB}
	doexe ${LIB}/libmojo*

	dodoc Linux.README

	newicon -s 512 Apotheon.png ${PN}.png
	make_desktop_entry ${PN} "Apotheon"
}

pkg_postinst() { xdg_icon_cache_update; }
pkg_postrm() { xdg_icon_cache_update; }
