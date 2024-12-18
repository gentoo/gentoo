# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1,3,4} luajit )
inherit cmake lua-single readme.gentoo-r1 xdg

DESCRIPTION="Open source reimplementation of TES III: Morrowind"
HOMEPAGE="https://openmw.org/ https://gitlab.com/OpenMW/openmw"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/OpenMW/openmw.git"
else
	SRC_URI="https://github.com/OpenMW/openmw/archive/${P}.tar.gz"
	S="${WORKDIR}/${PN}-${P}"
	KEYWORDS="~amd64 ~arm64 ~ppc64"
fi

# This particular commit is hardcoded in
# https://gitlab.com/OpenMW/openmw/-/blob/ffe164b28d3a10408e20fdadd2f0168c1e32fd6e/apps/components_tests/CMakeLists.txt#L114-118
MY_TEMPLATE_COMMIT="8966dab24692555eec720c854fb0f73d108070cd"
SRC_URI+="
	test? (
		https://gitlab.com/OpenMW/example-suite/-/raw/${MY_TEMPLATE_COMMIT}/game_template/data/template.omwgame
		-> openmw-template-${MY_TEMPLATE_COMMIT}.omwgame
	)
"

LICENSE="GPL-3 MIT BitstreamVera ZLIB"
SLOT="0"
IUSE="doc devtools +gui +osg-fork test"
REQUIRED_USE="${LUA_REQUIRED_USE}"
RESTRICT="!test? ( test )"

# TODO: Unbundle dev-games/openscenegraph-qt in extern/osgQt directory,
# used when BUILD_OPENCS flag is enabled.
# OpenMW has custom changes to this library.
# See bug #676266.

RDEPEND="${LUA_DEPS}
	app-arch/lz4:=
	dev-cpp/yaml-cpp:=
	dev-db/sqlite:3
	dev-games/recastnavigation:=
	>=dev-games/mygui-3.4.3:=
	dev-libs/boost:=[zlib]
	dev-libs/icu:=
	dev-libs/tinyxml[stl]
	media-libs/libsdl2[joystick,opengl,video]
	media-libs/openal
	media-video/ffmpeg:=
	>=sci-physics/bullet-2.86:=[double-precision]
	sys-libs/zlib
	virtual/opengl
	osg-fork? ( >=dev-games/openscenegraph-openmw-3.6:=[collada(-),jpeg,png,sdl,svg,truetype,zlib] )
	!osg-fork? ( >=dev-games/openscenegraph-3.6.5:=[collada(-),jpeg,png,sdl,svg,truetype,zlib] )
	gui? (
		app-arch/unshield
		dev-qt/qtbase:6[gui,network,opengl,widgets]
		dev-qt/qtsvg:6
	)
"

DEPEND="${RDEPEND}
	dev-cpp/sol2
"

BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/doxygen[dot]
		dev-python/sphinx
	)
	gui? (
		dev-qt/qttools:6[linguist]
	)
	test? (
		dev-cpp/gtest
	)
"

src_prepare() {
	cmake_src_prepare

	# Use the system tinyxml headers
	rm -v extern/oics/tiny{str,xml}* || die

	# Use the system sol2 (v3) headers
	rm -r extern/sol3 || die
}

src_configure() {
	use devtools && ! use gui &&
		elog "'gui' USE flag is disabled, 'openmw-cs' will not be installed"

	local mycmakeargs=(
		-DBUILD_BSATOOL=$(usex devtools)
		-DBUILD_DOCS=$(usex doc)
		-DBUILD_ESMTOOL=$(usex devtools)
		-DBUILD_LAUNCHER=$(usex gui)
		-DBUILD_OPENCS=$(usex devtools $(usex gui))
		-DBUILD_WIZARD=$(usex gui)
		-DBUILD_NIFTEST=$(usex devtools)
		-DBUILD_COMPONENTS_TESTS=$(usex test)
		-DBUILD_OPENMW_TESTS=$(usex test)
		-DBUILD_OPENCS_TESTS=$(usex test $(usex devtools))

		-DGLOBAL_DATA_PATH="${EPREFIX}/usr/share"
		-DICONDIR="${EPREFIX}/usr/share/icons/hicolor/256x256/apps"
		-DUSE_SYSTEM_TINYXML=ON
		-DOPENMW_USE_SYSTEM_GOOGLETEST=ON
		-DOPENMW_USE_SYSTEM_RECASTNAVIGATION=ON

		-DQT_DIR="${ESYSROOT}/usr/lib64/cmake/Qt6"
	)

	if [[ ${ELUA} == luajit ]]; then
		mycmakeargs+=(
			-DUSE_LUAJIT=ON
		)
	else
		mycmakeargs+=(
			-DUSE_LUAJIT=OFF
			-DLua_FIND_VERSION_MAJOR=$(ver_cut 1 $(lua_get_version))
			-DLua_FIND_VERSION_MINOR=$(ver_cut 2 $(lua_get_version))
			-DLua_FIND_VERSION_COUNT=2
			-DLua_FIND_VERSION_EXACT=ON
		)
	fi

	if use test ; then
		mkdir -p "${BUILD_DIR}"/apps/components_tests/data || die
		cp "${DISTDIR}"/openmw-template-${MY_TEMPLATE_COMMIT}.omwgame \
			"${BUILD_DIR}"/apps/components_tests/data/template.omwgame || die
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc ; then
		cmake_src_compile doc
		find "${BUILD_DIR}"/docs/Doxygen/html \
			-name '*.md5' -type f -delete || die
		HTML_DOCS=( "${BUILD_DIR}"/docs/Doxygen/html/. )
	fi
}

src_test() {
	# Lua 5.x is supported in theory, but don't work as well, the test fails
	# Upstream recommends luajit, but it has less arch coverage
	if [[ ${ELUA} != luajit ]]; then
		elog "Skipping tests on ${ELUA}"
		return
	fi

	pushd "${BUILD_DIR}" > /dev/null || die
	./components-tests || die
	./openmw-tests || die
	if use gui && use devtools; then
		./openmw-cs-tests || die
	fi
	popd > /dev/null || die
}

src_install() {
	cmake_src_install

	local DOC_CONTENTS="
	You need the original Morrowind data files. If you haven't
	installed them yet, you can install them straight via the
	installation wizard which is the officially supported method
	(either by using the launcher or by calling 'openmw-wizard'
	directly).\n"

	if ! use gui ; then
		DOC_CONTENTS+="\n\n
		USE flag 'gui' is disabled, 'openmw-launcher' and
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
	xdg_pkg_postinst
	readme.gentoo_print_elog
}
