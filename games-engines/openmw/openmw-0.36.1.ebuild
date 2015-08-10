# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils gnome2-utils cmake-utils games

DESCRIPTION="An open source reimplementation of TES III: Morrowind"
HOMEPAGE="http://openmw.org/"
SRC_URI="https://github.com/OpenMW/openmw/archive/${P}.tar.gz"

LICENSE="GPL-3 MIT BitstreamVera OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc devtools"

# XXX static build
RDEPEND="
	app-arch/unshield
	>=dev-games/mygui-3.2.1[ogre]
	>=dev-games/ogre-1.9.0[-double-precision,freeimage,ois,opengl,zip]
	>=dev-libs/boost-1.46.0
	dev-libs/tinyxml
	>=dev-qt/qtcore-4.7.0:4
	>=dev-qt/qtgui-4.7.0:4
	media-libs/freetype:2
	media-libs/libsdl2[X,video]
	media-libs/openal
	>=sci-physics/bullet-2.80
	virtual/ffmpeg
	devtools? ( dev-qt/qtxmlpatterns:4 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen media-gfx/graphviz )"

S=${WORKDIR}/${PN}-${P}

src_configure() {
	local mycmakeargs=(
		-DBINDIR="${GAMES_BINDIR}"
		$(cmake-utils_use_build devtools BSATOOL)
		$(cmake-utils_use_build devtools ESMTOOL)
		$(cmake-utils_use_build devtools OPENCS)
		-DBUILD_UNITTESTS=OFF
		-DDATADIR="${GAMES_DATADIR}"/${PN}
		-DICONDIR="/usr/share/icons/hicolor/256x256/apps"
		-DLIBDIR="$(games_get_libdir)"
		-DMORROWIND_DATA_FILES="${GAMES_DATADIR}"/morrowind-data
		-DOPENMW_RESOURCE_FILES="${GAMES_DATADIR}"/${PN}/resources
		-DGLOBAL_CONFIG_PATH="${GAMES_SYSCONFDIR}"
		-DUSE_SYSTEM_TINYXML=ON
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use doc ; then
		emake -C "${CMAKE_BUILD_DIR}" doc
	fi
}

src_install() {
	cmake-utils_src_install
	dodoc README.md

	# about 46835 files, dodoc seems to have trouble
	if use doc ; then
		dodir "/usr/share/doc/${PF}"
		find "${CMAKE_BUILD_DIR}"/docs/Doxygen/html \
			-name '*.md5' -type f -delete
		mv "${CMAKE_BUILD_DIR}"/docs/Doxygen/html \
			"${D}/usr/share/doc/${PF}/" || die
	fi

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update

	elog "You need the original Morrowind Data files. If you haven't"
	elog "installed them yet, you can install them straight via the"
	elog "installation wizard which is the officially"
	elog "supported method (either by using the launcher or by calling"
	elog "'openmw-wizard' directly)."
}

pkg_postrm() {
	gnome2_icon_cache_update
}
