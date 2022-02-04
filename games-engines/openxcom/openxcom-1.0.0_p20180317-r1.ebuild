# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

DESCRIPTION="Open-source reimplementation of the popular UFO: Enemy Unknown"
HOMEPAGE="https://openxcom.org/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/SupSuper/OpenXcom.git"
else
	COMMIT="ea9ac466221f8b4f8974d2db1c42dc4ad6126564"
	SRC_URI="https://github.com/SupSuper/OpenXcom/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
	S="${WORKDIR}/OpenXcom-${COMMIT}"
fi

LICENSE="GPL-3+ CC-BY-SA-4.0"
SLOT="0"
IUSE="doc"

RDEPEND="
	>=dev-cpp/yaml-cpp-0.5.1
	media-libs/libsdl[opengl,video]
	media-libs/sdl-gfx
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[flac,mikmod,vorbis]"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-doc/doxygen )"

DOCS=( README.md )

src_compile() {
	cmake_src_compile
	use doc && cmake_build doxygen
}

src_install() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/docs/html/. )
	cmake_src_install
}

pkg_postinst() {
	xdg_icon_cache_update

	elog "In order to play you need copy GEODATA, GEOGRAPH, MAPS, ROUTES, SOUND,"
	elog "TERRAIN, UFOGRAPH, UFOINTRO, UNITS folders from original X-COM game to"
	elog "/usr/share/${PN}/UFO"
	elog
	elog "If you want to play the TFTD mod, you need to copy ANIMS, FLOP_INT,"
	elog "GEODATA, GEOGRAPH, MAPS, ROUTES, SOUND, TERRAIN, UFOGRAPH, UNITS folders"
	elog "from the original Terror from the Deep game to"
	elog "/usr/share/${PN}/TFTD"
	elog
	elog "If you need or want text in some language other than english, download:"
	elog "https://openxcom.org/translations/latest.zip and uncompress it in"
	elog "/usr/share/${PN}/common/Language"
}

pkg_postrm() {
	xdg_icon_cache_update
}
