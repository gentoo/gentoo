# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils gnome2-utils cmake-utils

DESCRIPTION="An open source reimplementation of TES III: Morrowind"
HOMEPAGE="http://openmw.org/"
SRC_URI="https://github.com/OpenMW/openmw/archive/${P}.tar.gz"

LICENSE="GPL-3 MIT BitstreamVera OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc devtools"

RDEPEND="
	app-arch/unshield
	>=dev-games/mygui-3.2.2
	>=dev-games/openscenegraph-3.3.4[ffmpeg,jpeg,png,qt5,sdl,svg,truetype,zlib]
	>=dev-libs/boost-1.56.0-r1
	dev-libs/tinyxml
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	media-libs/freetype:2
	media-libs/libsdl2[joystick,opengl,X,video]
	|| ( media-libs/libtxc_dxtn x11-drivers/ati-drivers x11-drivers/nvidia-drivers )
	media-libs/openal
	>=sci-physics/bullet-2.80
	virtual/ffmpeg
	virtual/opengl
	devtools? ( dev-qt/qtxmlpatterns:5 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen media-gfx/graphviz )"

S=${WORKDIR}/${PN}-${P}

src_configure() {
	local mycmakeargs=(
		-DBINDIR="/usr/bin"
		-DBUILD_BSATOOL="$(usex devtools)"
		-DBUILD_ESMTOOL="$(usex devtools)"
		-DBUILD_OPENCS="$(usex devtools)"
		-DBUILD_UNITTESTS=OFF
		-DDATADIR="/usr/share/${PN}"
		-DICONDIR="/usr/share/icons/hicolor/256x256/apps"
		-DLIBDIR="/usr/$(get_libdir)"
		-DMORROWIND_DATA_FILES="/usr/share/morrowind-data"
		-DOPENMW_RESOURCE_FILES="/usr/share/${PN}/resources"
		-DGLOBAL_CONFIG_PATH="/etc"
		-DUSE_SYSTEM_TINYXML=ON
		-DDESIRED_QT_VERSION=5
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	if use doc ; then
		emake -C "${CMAKE_BUILD_DIR}" doc
		find "${CMAKE_BUILD_DIR}"/docs/Doxygen/html \
			-name '*.md5' -type f -delete || die
	fi
}

src_install() {
	cmake-utils_src_install
	dodoc README.md

	# about 47k files, dodoc seems to have trouble
	if use doc ; then
		dodir "/usr/share/doc/${PF}"
		mv "${CMAKE_BUILD_DIR}"/docs/Doxygen/html \
			"${D}/usr/share/doc/${PF}/" || die
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
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
