# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils gnome2-utils

DESCRIPTION="Open source reimplementation of TES III: Morrowind"
HOMEPAGE="https://openmw.org/"
SRC_URI="https://github.com/OpenMW/openmw/archive/${P}.tar.gz"

LICENSE="GPL-3 MIT BitstreamVera ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc devtools +qt5"

RDEPEND="
	>=dev-games/openscenegraph-3.3.4[ffmpeg,jpeg,png,qt5,sdl,svg,truetype,zlib]
	dev-games/mygui
	dev-libs/boost:=[threads]
	dev-libs/tinyxml[stl]
	media-libs/libsdl2[joystick,opengl,video,X]
	media-libs/openal
	|| ( media-libs/libtxc_dxtn x11-drivers/nvidia-drivers )
	media-video/ffmpeg:=
	>=sci-physics/bullet-2.86
	virtual/opengl
	qt5? (
		app-arch/unshield
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
		dev-qt/qtopengl:5
		dev-qt/qtwidgets:5
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-python/sphinx
		media-gfx/graphviz
	)
"

S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	cmake-utils_src_prepare

	# We don't install license files
	sed -e '/LICDIR/d' \
		-i CMakeLists.txt || die
	# Use the system tinyxml headers
	sed -e 's/"tinyxml.h"/<tinyxml.h>/g' \
		-e 's/"tinystr.h"/<tinystr.h>/g' \
		-i extern/oics/ICSPrerequisites.h || die
}

src_configure() {
	use devtools && ! use qt5 && \
		elog "'qt5' USE flag is disabled, 'openmw-cs' will not be installed"

	local mycmakeargs=(
		-DBUILD_BSATOOL=$(usex devtools)
		-DBUILD_ESMTOOL=$(usex devtools)
		-DBUILD_OPENCS=$(usex devtools $(usex qt5))
		-DBUILD_NIFTEST=$(usex devtools)
		-DBUILD_LAUNCHER=$(usex qt5)
		-DBUILD_WIZARD=$(usex qt5)
		-DBUILD_UNITTESTS=OFF
		-DGLOBAL_DATA_PATH=/usr/share
		-DICONDIR="/usr/share/icons/hicolor/256x256/apps"
		-DMORROWIND_DATA_FILES="/usr/share/morrowind-data"
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

	# about 43k files, dodoc seems to have trouble
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

	elog "You need the original Morrowind data files. If you haven't"
	elog "installed them yet, you can install them straight via the"
	elog "installation wizard which is the officially supported method"
	elog "(either by using the launcher or by calling 'openmw-wizard'"
	elog "directly)."

	if ! use qt5; then
		elog
		elog "'qt5' USE flag is disabled, 'openmw-launcher' and"
		elog "'openmw-wizard' are not available. You are on your own for"
		elog "making the Morrowind data files available and pointing"
		elog "openmw at them."
		elog
		elog "Additionally; you must import the Morrowind.ini file before"
		elog "running openmw with the Morrowind data files for the first"
		elog "time. Typically this can be done like so:"
		elog
		elog "    mkdir -p ~/.config/openmw"
		elog "    openmw-iniimporter /path/to/Morrowind.ini ~/.config/openmw/openmw.cfg"
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
