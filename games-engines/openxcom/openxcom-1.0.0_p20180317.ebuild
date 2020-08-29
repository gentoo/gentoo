# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils gnome2-utils

COMMIT="ea9ac466221f8b4f8974d2db1c42dc4ad6126564"
DESCRIPTION="An open-source reimplementation of the popular UFO: Enemy Unknown"
HOMEPAGE="https://openxcom.org/"
SRC_URI="https://github.com/SupSuper/OpenXcom/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+ CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc"

RDEPEND=">=dev-cpp/yaml-cpp-0.5.1
	media-libs/libsdl[opengl,video]
	media-libs/sdl-gfx
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[flac,mikmod,vorbis]"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

S="${WORKDIR}/OpenXcom-${COMMIT}"
DOCS=( README.md )

src_compile() {
	use doc && cmake-utils_src_compile doxygen
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	use doc && dodoc -r "${CMAKE_BUILD_DIR}"/docs/html/*
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	echo
	elog "In order to play you need copy GEODATA, GEOGRAPH, MAPS, ROUTES, SOUND,"
	elog "TERRAIN, UFOGRAPH, UFOINTRO, UNITS folders from original X-COM game to"
	elog "/usr/share/${PN}/UFO"
	echo
	elog "If you want to play the TFTD mod, you need to copy ANIMS, FLOP_INT,"
	elog "GEODATA, GEOGRAPH, MAPS, ROUTES, SOUND, TERRAIN, UFOGRAPH, UNITS folders"
	elog "from the original Terror from the Deep game to"
	elog "/usr/share/${PN}/TFTD"
	echo
	elog "If you need or want text in some language other than english, download:"
	elog "https://openxcom.org/translations/latest.zip and uncompress it in"
	elog "/usr/share/${PN}/common/Language"
}

pkg_postrm() {
	gnome2_icon_cache_update
}
