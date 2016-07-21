# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils cmake-utils gnome2-utils git-r3 games

DESCRIPTION="An open-source reimplementation of the popular UFO: Enemy Unknown"
HOMEPAGE="http://openxcom.org/"
EGIT_REPO_URI="https://github.com/SupSuper/OpenXcom.git"

LICENSE="GPL-3+ CC-BY-SA-4.0"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND=">=dev-cpp/yaml-cpp-0.5.1
	media-libs/libsdl[opengl,video]
	media-libs/sdl-gfx
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[flac,mikmod,vorbis]"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	cmake-utils_src_prepare
	sed -i -e '/\/res\//d' CMakeLists.txt || die
}

src_configure() {
	mycmakeargs=(
		"-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}"
		"-DCMAKE_INSTALL_DATADIR=${GAMES_DATADIR}"
	)
	cmake-utils_src_configure
}

src_compile() {
	use doc && cmake-utils_src_compile doxygen
	cmake-utils_src_compile
}

src_install() {
	DOCS="README.md" \
		cmake-utils_src_install
	use doc && dohtml -r "${CMAKE_BUILD_DIR}"/docs/html/*
	doicon -s scalable res/linux/icons/openxcom.svg
	newicon -s 48 res/linux/icons/openxcom_48x48.png openxcom.png
	newicon -s 128 res/linux/icons/openxcom_128x128.png openxcom.png
	domenu res/linux/openxcom.desktop

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
	echo
	elog "In order to play you need copy GEODATA, GEOGRAPH, MAPS, ROUTES, SOUND,"
	elog "TERRAIN, UFOGRAPH, UFOINTRO, UNITS folders from original X-COM game to"
	elog "${GAMES_DATADIR}/${PN}/UFO"
	echo
	elog "If you want to play the TFTD mod, you need to copy ANIMS, FLOP_INT,"
	elog "GEODATA, GEOGRAPH, MAPS, ROUTES, SOUND, TERRAIN, UFOGRAPH, UNITS folders"
	elog "from the original Terror from the Deep game to"
	elog "${GAMES_DATADIR}/${PN}/TFTD"
	echo
	elog "If you need or want text in some language other than english, download:"
	elog "http://openxcom.org/translations/latest.zip and uncompress it in"
	elog "${GAMES_DATADIR}/${PN}/common/Language"
}

pkg_postrm() {
	gnome2_icon_cache_update
}
