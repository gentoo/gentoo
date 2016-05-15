# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

CMAKE_WARN_UNUSED_CLI=yes
inherit eutils cmake-utils gnome2-utils games

DESCRIPTION="Cross-platform port of Arx Fatalis, a first-person role-playing game"
HOMEPAGE="http://arx-libertatis.org/"
SRC_URI="mirror://sourceforge/arx/${P}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="c++0x debug +unity-build crash-reporter static tools"

COMMON_DEPEND="
	media-libs/freetype
	media-libs/libsdl[X,video,opengl]
	media-libs/openal
	sys-libs/zlib
	virtual/opengl
	crash-reporter? (
		dev-qt/qtcore:4[ssl]
		dev-qt/qtgui:4
	)
	!static? ( media-libs/glew )"
RDEPEND="${COMMON_DEPEND}
	crash-reporter? ( sys-devel/gdb )"
DEPEND="${COMMON_DEPEND}
	dev-libs/boost
	virtual/pkgconfig
	static? ( media-libs/glew[static-libs] )"

DOCS=( README.md AUTHORS CHANGELOG )

PATCHES=(
	"${FILESDIR}"/${P}-cmake-3.5.patch
)

src_configure() {
	# editor does not build
	local mycmakeargs=(
		$(cmake-utils_use_build crash-reporter CRASHREPORTER)
		-DBUILD_EDITOR=OFF
		$(cmake-utils_use_build tools TOOLS)
		-DCMAKE_INSTALL_DATAROOTDIR="${GAMES_DATADIR_BASE}"
		-DCMAKE_INSTALL_PREFIX="${GAMES_PREFIX}"
		$(cmake-utils_use debug DEBUG)
		-DGAMESBINDIR="${GAMES_BINDIR}"
		-DICONDIR=/usr/share/icons/hicolor/128x128/apps
		-DINSTALL_SCRIPTS=ON
		-DSET_OPTIMIZATION_FLAGS=OFF
		-DSTRICT_USE=ON
		$(cmake-utils_use unity-build UNITY_BUILD)
		$(cmake-utils_use_use c++0x CXX11)
		-DUSE_NATIVE_FS=ON
		-DUSE_OPENAL=ON
		-DUSE_OPENGL=ON
		-DUSE_SDL=ON
		$(usex crash-reporter "-DUSE_QT5=OFF" "")
		$(cmake-utils_use_use static STATIC_LIBS)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	elog "optional dependencies:"
	elog "  games-rpg/arx-fatalis-data (from CD or GOG)"
	elog "  games-rpg/arx-fatalis-demo (free demo)"
	elog
	elog "This package only installs the game binary."
	elog "You need the demo or full game data. Also see:"
	elog "http://wiki.arx-libertatis.org/Getting_the_game_data"
	elog
	elog "If you have already installed the game or use the STEAM version,"
	elog "run \"${GAMES_BINDIR}/arx-install-data\""

	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
