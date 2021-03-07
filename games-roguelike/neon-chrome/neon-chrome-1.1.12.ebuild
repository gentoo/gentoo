# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils desktop xdg-utils

MY_PN="NeonChrome"
DESCRIPTION="A ruthless top-down cyberpunk shooter with rogue-like elements"
HOMEPAGE="https://neonchromegame.com/"
SRC_URI="${MY_PN}-Linux-${PV}.tar"
#	https://dev.gentoo.org/~chewi/distfiles/${PN}.png"
LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist fetch splitdebug"

RDEPEND="
	media-libs/libsdl2[opengl,video]
	media-libs/openal
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
	doins *.pak *.xml

	dodoc README.txt

#	doicon -s 64 "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} "Neon Chrome" applications-games
}

pkg_postinst() { xdg_icon_cache_update; }
pkg_postrm() { xdg_icon_cache_update; }
