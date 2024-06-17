# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
LUA_COMPAT=( luajit )
PYTHON_COMPAT=( python3_{10..12} )
PVCUT=$(ver_cut 1-3)
KFMIN=5.115.0
QTMIN=5.15.12
inherit ecm gear.kde.org lua-single optfeature python-single-r1

DESCRIPTION="Interface for doing mathematics and scientific computing"
HOMEPAGE="https://apps.kde.org/cantor/ https://edu.kde.org/cantor/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 arm64 ~x86"
# TODO: restore +analitza once cantor is ported to Qt6
IUSE="julia lua postscript python qalculate R"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} ) python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="test"

# TODO Add Sage Mathematics Software backend (https://www.sagemath.org)
# analitza? ( >=kde-apps/analitza-23.08.4:5 )
DEPEND="
	app-text/poppler[qt5]
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qthelp-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwebengine-${QTMIN}:5[widgets]
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=dev-qt/qtxmlpatterns-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kcompletion-${KFMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:5
	>=kde-frameworks/kconfigwidgets-${KFMIN}:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/kcrash-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kiconthemes-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/knewstuff-${KFMIN}:5
	>=kde-frameworks/kparts-${KFMIN}:5
	>=kde-frameworks/ktexteditor-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/syntax-highlighting-${KFMIN}:5
	julia? ( dev-lang/julia )
	lua? ( ${LUA_DEPS} )
	qalculate? (
		sci-libs/cln
		sci-libs/libqalculate:=
	)
	postscript? ( app-text/libspectre )
	python? (
		${PYTHON_DEPS}
		>=dev-qt/qtdbus-${QTMIN}:5
	)
	R? ( dev-lang/R )
"
# !analitza?
RDEPEND="${DEPEND}
	!julia? ( !lua? ( !python? ( !qalculate? ( !R? (
		|| (
			sci-mathematics/maxima
			sci-mathematics/octave
		)
	) ) ) ) )
"
BDEPEND="x11-misc/shared-mime-info"

pkg_setup() {
	use lua && lua-single_pkg_setup
	use python && python-single-r1_pkg_setup
	ecm_pkg_setup
}

src_configure() {
	use julia && addpredict /proc/self/mem # bug 602894

	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_Analitza5=ON
		$(cmake_use_find_package julia Julia)
		$(cmake_use_find_package lua LuaJIT)
		-DUSE_LIBSPECTRE=$(usex postscript)
		$(cmake_use_find_package python Python3)
		$(cmake_use_find_package qalculate Qalculate)
		$(cmake_use_find_package R R)
	)
	use lua && mycmakeargs+=(
		-DLUAJIT_INCLUDEDIR="${EPREFIX}/$(lua_get_include_dir)"
		-DLUAJIT_LIBDIR="${EPREFIX}/$(lua_get_cmod_dir)"
	)
	ecm_src_configure
}

src_compile() {
	# -j1 for bug #919576
	MAKEOPTS="-j1" ecm_src_compile
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "Maxima backend" sci-mathematics/maxima
		optfeature "Octave backend" sci-mathematics/octave
		optfeature "LaTeX support" virtual/latex-base
	fi
	ecm_pkg_postinst
}
