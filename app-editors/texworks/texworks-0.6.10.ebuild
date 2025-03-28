# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-{1..4} )
PYTHON_COMPAT=( python3_{10..13} )
CMAKE_REMOVE_MODULES_LIST=( FindLua )
inherit lua-single python-single-r1 cmake xdg

DESCRIPTION="Simple interface for working with TeX documents"
HOMEPAGE="https://tug.org/texworks/"
SRC_URI="https://github.com/TeXworks/texworks/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-release-${PV}"

LICENSE="GPL-2+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="lua python test"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	lua? ( ${LUA_REQUIRED_USE} )
	python? ( ${PYTHON_REQUIRED_USE} )
"

RDEPEND="
	app-text/hunspell:=
	app-text/poppler[qt6]
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[concurrent,dbus,gui,widgets,xml]
	dev-qt/qtdeclarative:6
	dev-qt/qttools:6[widgets]
	sys-libs/zlib
	lua? ( ${LUA_DEPS} )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.10-cmake_lua_version.patch
)

pkg_setup() {
	use lua && lua-single_pkg_setup

	python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-Wno-dev
		-DPREFER_BUNDLED_SYNCTEX=ON
		-DWITH_LUA=$(usex lua)
		-DWITH_PYTHON=$(usex python)
		-DWITH_TESTS=$(usex test)
		-DTeXworks_PLUGIN_DIR="/usr/$(get_libdir)/texworks"
		-DTeXworks_DOCS_DIR="/share/doc/${PF}"
		-DQTPDF_VIEWER=ON
		-DBUILD_SHARED_PLUGINS=ON
		-DQT_DEFAULT_MAJOR_VERSION=6
		-DTW_BUILD_ID="Gentoo official package"
	)

	use lua && mycmakeargs+=( -DLUA_VERSION="$(lua_get_version)" )

	cmake_src_configure
}

src_test() {
	local -x QT_QPA_PLATFORM=offscreen
	cmake_src_test
}
