# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker xdg-utils

DESCRIPTION="A Metroidvania-style action-platformer set in a magical Mexican-inspired world"
HOMEPAGE="http://guacamelee.com"
SRC_URI="Guacamelee_linux_1393037377.sh"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch splitdebug"

RDEPEND="
	media-libs/libsdl2[abi_x86_32,joystick,opengl,sound,threads,video]
	virtual/opengl[abi_x86_32]
"

S="${WORKDIR}/data"

DIR="/opt/${PN}"
QA_PREBUILT="${DIR}/*"

pkg_nofetch() {
	einfo "This package requires the Guacamelee! Gold Edition file included in"
	einfo "Humble Indie Bundle 11. If you have it then please move"
	einfo "${SRC_URI} to your distfiles directory. If you"
	einfo "missed it then the game is also available to buy from GOG but the"
	einfo "package will need adapting first. Please contact the Gentoo Games team"
	einfo "if you bought it from GOG."
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	exeinto "${DIR}"
	newexe x86/game-bin ${PN}
	dosym "${DIR}"/${PN} /usr/bin/${PN}

	insinto "${DIR}"
	doins -r noarch/{*.dat*,media/}

	exeinto "${DIR}/lib32"
	doexe x86/lib32/libfmod*.so

	dodoc noarch/README.linux

	newicon -s 512 noarch/Guacamelee.png ${PN}.png
	make_desktop_entry ${PN} "Guacamelee"
}

pkg_postinst() { xdg_icon_cache_update; }
pkg_postrm() { xdg_icon_cache_update; }
