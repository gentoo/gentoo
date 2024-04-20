# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..3} )
PYTHON_COMPAT=( python3_{9..12} )
CMAKE_REMOVE_MODULES_LIST=( FindLua )
inherit lua-single python-single-r1 cmake xdg

DESCRIPTION="Simple interface for working with TeX documents"
HOMEPAGE="https://tug.org/texworks/"
SRC_URI="https://github.com/TeXworks/texworks/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-release-${PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"
IUSE="lua python test"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	app-text/hunspell:=
	app-text/poppler[qt5]
	dev-qt/designer:5
	dev-qt/qtcore:5
	dev-qt/qtconcurrent:5
	dev-qt/qtdeclarative:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	sys-libs/zlib
	lua? ( ${LUA_DEPS} )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"
BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.5-cmake_lua_version.patch
	"${FILESDIR}"/${P}-optional-qtscript.patch
)

pkg_setup() {
	use lua && lua-single_pkg_setup

	python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-Wno-dev
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5Script=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_Qt5ScriptTools=ON
		-DPREFER_BUNDLED_SYNCTEX=ON
		-DWITH_LUA=$(usex lua)
		-DWITH_PYTHON=$(usex python)
		-DWITH_TESTS=$(usex test)
		-DTeXworks_PLUGIN_DIR="/usr/$(get_libdir)/texworks"
		-DTeXworks_DOCS_DIR="/share/doc/${PF}"
		-DQTPDF_VIEWER=ON
		-DBUILD_SHARED_PLUGINS=ON
	)

	use lua && mycmakeargs+=( -DLUA_VERSION="$(lua_get_version)" )

	cmake_src_configure
}

src_test() {
	local -x QT_QPA_PLATFORM=offscreen
	cmake_src_test
}
