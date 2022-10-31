# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..3} luajit )

inherit desktop flag-o-matic lua-single xdg cmake

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/CelestiaProject/Celestia.git"
	inherit git-r3
else
	if [[ ${PV} == *_p* ]] ; then
		COMMIT_ID="df508a0c597a3d96c1c039fa4a973e294021cfba"
		SRC_URI="https://github.com/${PN^}Project/${PN^}/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"
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
	nls? (
		sys-devel/gettext
		virtual/libintl
	)
"
DEPEND="
	<dev-libs/libfmt-9.0.0:=
	media-libs/freetype
	media-libs/glew:0=
	media-libs/libepoxy
	media-libs/libglvnd
	media-libs/libjpeg-turbo:0=
	media-libs/libpng:0=
	sys-libs/zlib:=
	virtual/glu
	virtual/opengl
	ffmpeg? ( media-video/ffmpeg )
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
	cmake_src_prepare

	### This version of Celestia has a bug in the font rendering and
	### requires -fsigned-char. We should be able to force this flag
	### on all architectures. See bug #316573.
	append-flags "-fsigned-char"
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_CELX="$(usex lua)"
		-DENABLE_NLS="$(usex nls)"
		-DENABLE_GLUT="$(usex glut)"
		-DENABLE_GTK=OFF
		-DENABLE_QT="$(usex qt5)"
		-DENABLE_WIN=OFF
		-DENABLE_FFMPEG="$(usex ffmpeg)"
	)
	# Upstream always looks for LuaJIT first unless stopped, and we only need
	# the version specification when linking against PUC Lua
	if use lua && ! use lua_single_target_luajit ; then
		mycmakeargs+=(
			-DCMAKE_DISABLE_FIND_PACKAGE_LuaJIT=ON
			-DLUA_VERSION=$(lua_get_version)
		)
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install

	newicon -s 128 "${S}"/src/celestia/gtk/data/${PN}-logo.png ${PN}.png
	doicon -s scalable "${S}"/src/celestia/gtk/data/${PN}.svg

	local backend
	for backend in glut qt5 ; do
		use ${backend} && domenu debian/celestia-${backend/qt5/qt}.desktop
	done

	dodoc AUTHORS README TRANSLATORS *.txt
}
