# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils readme.gentoo-r1

DESCRIPTION="Open source reimplementation of TES III: Morrowind"
HOMEPAGE="https://openmw.org/"
SRC_URI="https://github.com/OpenMW/openmw/archive/${P}.tar.gz"

LICENSE="GPL-3 MIT BitstreamVera ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc devtools +qt5"

# FIXME: Unbundle dev-games/openscenegraph-qt in extern/osgQt directory,
# used when BUILD_OPENCS flag is enabled. See bug #676266.

RDEPEND="
	dev-games/mygui
	>=dev-games/openscenegraph-3.5.5:=[ffmpeg,jpeg,png,sdl,svg,truetype,zlib]
	dev-libs/boost:=[threads]
	dev-libs/tinyxml[stl]
	media-libs/libsdl2[joystick,opengl,video]
	media-libs/openal
	media-video/ffmpeg:=
	>=sci-physics/bullet-2.86:=
	virtual/opengl
	qt5? (
		app-arch/unshield
		dev-qt/qtcore:5=
		dev-qt/qtgui:5=
		dev-qt/qtnetwork:5=
		dev-qt/qtopengl:5=
		dev-qt/qtwidgets:5=
	)
"

DEPEND="${RDEPEND}"

BDEPEND="
	virtual/pkgconfig
	doc? (
		app-doc/doxygen[doc]
		dev-python/sphinx
	)
"

S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	cmake_src_prepare

	# We don't install license files
	sed -i '/LICDIR/d' CMakeLists.txt || die

	# Use the system tinyxml headers
	rm -v extern/oics/tiny{str,xml}* || die
}

src_configure() {
	use devtools && ! use qt5 && \
		elog "'qt5' USE flag is disabled, 'openmw-cs' will not be installed"

	local mycmakeargs=(
		-DBUILD_BSATOOL=$(usex devtools)
		-DBUILD_DOCS=$(usex doc)
		-DBUILD_ESMTOOL=$(usex devtools)
		-DBUILD_LAUNCHER=$(usex qt5)
		-DBUILD_NIFTEST=$(usex devtools)
		-DBUILD_OPENCS=$(usex devtools $(usex qt5))
		-DBUILD_WIZARD=$(usex qt5)
		-DBUILD_UNITTESTS=OFF
		-DGLOBAL_DATA_PATH=/usr/share
		-DICONDIR="/usr/share/icons/hicolor/256x256/apps"
		-DMORROWIND_DATA_FILES="/usr/share/morrowind-data"
		-DUSE_SYSTEM_TINYXML=ON
		-DDESIRED_QT_VERSION=5
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc ; then
		cmake_src_compile doc
		find "${CMAKE_BUILD_DIR}"/docs/Doxygen/html \
			-name '*.md5' -type f -delete || die
		HTML_DOCS=( "${CMAKE_BUILD_DIR}"/docs/Doxygen/html/. )
	fi
}

src_install() {
	cmake_src_install

	local DOC_CONTENTS="
	You need the original Morrowind data files. If you haven't
	installed them yet, you can install them straight via the
	installation wizard which is the officially supported method
	(either by using the launcher or by calling 'openmw-wizard'
	directly).\n"

	if ! use qt5; then
		local DOC_CONTENTS+="\n\n
		USE flag 'qt5' is disabled, 'openmw-launcher' and
		'openmw-wizard' are not available. You are on your own for
		making the Morrowind data files available and pointing
		openmw at them.\n\n
		Additionally; you must import the Morrowind.ini file before
		running openmw with the Morrowind data files for the first
		time. Typically this can be done like so:\n\n
		\t mkdir -p ~/.config/openmw\n
		\t openmw-iniimporter /path/to/Morrowind.ini ~/.config/openmw/openmw.cfg"
	fi

	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_icon_cache_update
	readme.gentoo_print_elog
}

pkg_postrm() {
	xdg_icon_cache_update
}
