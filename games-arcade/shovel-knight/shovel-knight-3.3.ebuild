# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker wrapper xdg-utils

MY_PN="ShovelKnight"
DESCRIPTION="Sweeping classic action adventure with an 8-bit retro aesthetic"
HOMEPAGE="https://yachtclubgames.com/shovel-knight/"
SRC_URI="${PN//-/_}_treasure_trove_en_3_3_15418.sh"

LICENSE="Yacht-Club-Games-EULA"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
RESTRICT="bindist fetch splitdebug"

# I packaged Box2D in the hope of unbundling it but it turns out this
# game uses a custom version. -- Chewi :(

RDEPEND="
	media-libs/glew:1.10
	media-libs/libsdl2[opengl,sound,video]
	virtual/opengl
"

S="${WORKDIR}/data/noarch/game"

DIR="/opt/${PN}"
QA_PREBUILT="${DIR#/}/*"

pkg_nofetch() {
	einfo "Please buy and download ${SRC_URI} from:"
	einfo "  https://www.gog.com/game/${PN//-/_}"
	einfo "and move it to your distfiles directory."
}

src_unpack() {
	unpack_zip ${A}
}

src_install() {
	local BITS=$(usex amd64 64 32) LIB=

	exeinto "${DIR}"
	doexe ${BITS}/${MY_PN}
	make_wrapper ${MY_PN} ./${MY_PN} "${DIR}"

	exeinto "${DIR}"/lib
	doexe ${BITS}/lib/lib{Box2D.so.*,fmod*-*.so}

	# The FMOD libraries are duplicated rather than symlinked, which is
	# silly, so create our own symlinks. Both sets of names are needed.
	for LIB in ${BITS}/lib/libfmod*-*.so; do
		LIB=${LIB##*/}
		dosym "${LIB}" "${DIR}/lib/${LIB%-*}.so"
	done

	insinto "${DIR}"
	doins -r data/

	newicon -s 256 ../support/icon.png ${PN}.png
	make_desktop_entry ${MY_PN} "Shovel Knight"
}

pkg_postinst() { xdg_icon_cache_update; }
pkg_postrm() { xdg_icon_cache_update; }
