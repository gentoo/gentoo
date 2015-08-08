# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils cmake-utils gnome2-utils games

DESCRIPTION="An open-source reimplementation of the popular UFO: Enemy Unknown"
HOMEPAGE="http://openxcom.org/"
SRC_URI="https://github.com/SupSuper/OpenXcom/archive/v1.0.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 CC-BY-SA-4.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND=">=dev-cpp/yaml-cpp-0.5.1
	media-libs/libsdl[opengl,video]
	media-libs/sdl-gfx
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[flac,mikmod,vorbis]"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"

DOCS=( README.txt )

S=${WORKDIR}/OpenXcom-1.0

src_configure() {
	mycmakeargs=(
		"-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}"
		"-DDATADIR=${GAMES_DATADIR}/${PN}"
	)
	cmake-utils_src_configure
}

src_compile() {
	use doc && cmake-utils_src_compile doxygen
	cmake-utils_src_compile
}

src_install() {
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
	elog "${GAMES_DATADIR}/${PN}/data"
	echo
	elog "If you need or want text in some language other than english, download:"
	elog "http://openxcom.org/translations/latest.zip and uncompress it in"
	elog "${GAMES_DATADIR}/${PN}/data/Language"
}

pkg_postrm() {
	gnome2_icon_cache_update
}
