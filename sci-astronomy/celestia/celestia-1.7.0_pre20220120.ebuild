# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
CMAKE_IN_SOURCE_BUILD="yes"
LUA_COMPAT=( lua5-{1..3} luajit )

inherit desktop lua-single xdg cmake

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/CelestiaProject/Celestia.git"
	inherit git-r3
else
	if [[ ${PV} == *_p* ]] ; then
		COMMIT_ID="f969b37c3ee783ed51bf4d1cbeefca4132031316"
		COMMIT_ID_DATA="cc0bc0bb4b77e47115a31fbeb42babb30da3b790"
		SRC_URI="
			https://github.com/${PN^}Project/${PN^}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz
			https://github.com/${PN^}Project/${PN^}Content/archive/${COMMIT_ID_DATA}.tar.gz -> ${P}-data.tar.gz
		"
		S="${WORKDIR}/${PN^}-${COMMIT_ID}"
		KEYWORDS="~amd64 ~x86"
	else
		SRC_URI="https://github.com/${PN^}Project/${PN^}/archive/${PV/_/-}.tar.gz -> ${P}.tar.gz"
	fi
fi

DESCRIPTION="OpenGL 3D space simulator"
HOMEPAGE="https://celestia.space"

LICENSE="GPL-2+"
SLOT="0"
IUSE="ffmpeg glut lua nls +qt5"
REQUIRED_USE="|| ( glut qt5 )
	lua? ( ${LUA_REQUIRED_USE} )"

BDEPEND="
	dev-cpp/eigen
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
DEPEND="
	<dev-libs/libfmt-9.0.0:=
	media-libs/glew:0=
	media-libs/libepoxy
	media-libs/libjpeg-turbo:0=
	media-libs/libpng:0=
	sys-libs/zlib:=
	virtual/glu
	virtual/opengl
	ffmpeg? ( media-video/ffmpeg:0 )
	glut? ( media-libs/freeglut )
	lua? ( ${LUA_DEPS} )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtopengl:5
		dev-qt/qtwidgets:5
	)
"
RDEPEND="${DEPEND}"

PATCHES=(
	# add a ~/.celestia for extra directories
	"${FILESDIR}"/${PN}-1.6.99-cfg.patch
	# allow forcing CMake to look for a specific Lua version instead of the newest branch installed
	"${FILESDIR}"/${PN}-1.7.0-cmake_lua_version.patch
)

src_prepare() {
	mv "${WORKDIR}"/CelestiaContent-${COMMIT_ID_DATA} content || die

	cmake_src_prepare
	### This version of Celestia has a bug in the font rendering and
	### requires -fsigned-char. We should be able to force this flag
	### on all architectures. See bug #316573.
	# FIXME: Point to upstream bug report if still valid
	#append-flags "-fsigned-char"
}

src_configure() {
	CMAKE_USE_DIR="${CMAKE_USE_DIR}/content" BUILD_DIR="${BUILD_DIR}/content" \
		cmake_src_configure

	local mycmakeargs=(
		-DENABLE_CELX="$(usex lua)"
		-DENABLE_NLS="$(usex nls)"
		-DENABLE_FFMPEG="$(usex ffmpeg)"
		-DENABLE_GLUT="$(usex glut)"
		-DENABLE_GTK=OFF
		-DENABLE_QT="$(usex qt5)"
		-DENABLE_WIN=OFF
		-DENABLE_SDL=OFF
	)
	# Upstream always looks for LuaJIT first unless stopped, and we only need
	# the version specification when linking against PUC Lua
	if use lua && ! use lua_single_target_luajit; then
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_LuaJIT=ON
			-DLUA_VERSION=$(lua_get_version)
		)
	fi
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	CMAKE_USE_DIR="${CMAKE_USE_DIR}/content" BUILD_DIR="${BUILD_DIR}/content" cmake_src_compile
}

src_install() {
	cmake_src_install

	doicon -s 48 "${S}"/src/celestia/gtk/data/${PN}.png
	newicon -s 128 "${S}"/src/celestia/gtk/data/${PN}-logo.png ${PN}.png
	doicon -s scalable "${S}"/src/celestia/gtk/data/${PN}.svg

	use glut && domenu "${S}"/debian/${PN}-glut.desktop
	use qt5 && domenu "${S}"/debian//${PN}-qt.desktop

	dodoc AUTHORS README TRANSLATORS *.txt

	CMAKE_USE_DIR="${CMAKE_USE_DIR}/content" BUILD_DIR="${BUILD_DIR}/content" cmake_src_install
}
