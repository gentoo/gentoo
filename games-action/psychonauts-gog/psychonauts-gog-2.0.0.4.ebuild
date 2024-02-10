# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHECKREQS_DISK_BUILD="5238M"
inherit check-reqs desktop unpacker wrapper xdg

MY_PN="Psychonauts"

DESCRIPTION="A mind-bending platforming adventure from Double Fine Productions"
HOMEPAGE="https://www.doublefine.com/games/psychonauts"
SRC_URI="gog_${MY_PN,,}_${PV}.sh"

LICENSE="GOG-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="bindist fetch splitdebug"

BDEPEND="
	app-arch/unzip
"

RDEPEND="
	media-libs/libsdl[abi_x86_32,opengl,video]
	media-libs/openal[abi_x86_32]
	>=sys-devel/gcc-3.4[cxx]
	sys-libs/glibc
	!${CATEGORY}/${MY_PN,,}
	!${CATEGORY}/${MY_PN,,}-hb
"

S="${WORKDIR}/data/noarch"
DIR="/opt/${MY_PN,,}"
QA_PREBUILT="${DIR#/}/*"

pkg_nofetch() {
	elog "Please buy and download ${SRC_URI} from:"
	elog "  https://www.gog.com/game/${MY_PN,,}"
	elog "and move it to your distfiles directory."
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	exeinto "${DIR}"
	doexe game/${MY_PN}
	make_wrapper ${MY_PN,,} "${DIR}"/${MY_PN}

	insinto "${DIR}"
	doins -r game/{icon.bmp,WorkResource/,*.pkg}

	newicon -s 256 support/icon.png ${MY_PN,,}.png
	make_desktop_entry ${MY_PN,,} ${MY_PN} ${MY_PN,,}

	dodoc \
		docs/"Psychonauts Manual Win.pdf" \
		game/Documents/Readmes/*.txt
}
