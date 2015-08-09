# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CMAKE_IN_SOURCE_BUILD=1
WX_GTK_VER="3.0"
inherit eutils cmake-utils gnome2-utils wxwidgets games

MY_P="CorsixTH-${PV}-Source"

DESCRIPTION="Open source clone of Theme Hospital"
HOMEPAGE="https://github.com/CorsixTH/CorsixTH"
SRC_URI="https://github.com/CorsixTH/CorsixTH/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ffmpeg mapeditor truetype opengl +sound"

RDEPEND=">=dev-lang/lua-5.1
	media-libs/libsdl[X]
	ffmpeg? ( virtual/ffmpeg )
	mapeditor? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )
	truetype? ( media-libs/freetype:2 )
	opengl? ( virtual/opengl )
	sound? ( media-libs/sdl-mixer )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/CorsixTH-${PV}

pkg_setup() {
	games_pkg_setup

	if use mapeditor && use !opengl ; then
		eerror "need opengl enabled for mapeditor to work!"
		die "need opengl enabled for mapeditor to work!"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-install.patch
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with opengl OPENGL)
		$(cmake-utils_use_with sound AUDIO)
		$(cmake-utils_use_with truetype FREETYPE2)
		$(cmake-utils_use_with ffmpeg MOVIES)
		$(cmake-utils_use_build mapeditor MAPEDITOR)
		-DCMAKE_INSTALL_PREFIX="${GAMES_DATADIR}"
		-DBINDIR="$(games_get_libdir)/${PN}"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	DOCS="CorsixTH/changelog.txt" cmake-utils_src_install
	games_make_wrapper ${PN} "$(games_get_libdir)/${PN}/CorsixTH" \
		"${GAMES_DATADIR}/CorsixTH"
	games_make_wrapper ${PN}-mapedit "$(games_get_libdir)/${PN}/MapEdit" \
		"${GAMES_DATADIR}/CorsixTH"
	newicon -s scalable CorsixTH/Original_Logo.svg ${PN}.svg
	make_desktop_entry ${PN}
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	elog "optional dependencies:"
	elog "  media-libs/sdl-mixer[timidity] (MIDI sound support)"

	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
