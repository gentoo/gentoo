# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_MAKEFILE_GENERATOR="emake"
ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
LUA_COMPAT=( luajit )
PYTHON_COMPAT=( python3_{7,8,9} )
PVCUT=$(ver_cut 1-3)
KFMIN=5.75.0
QTMIN=5.15.1
inherit ecm kde.org lua-single optfeature python-single-r1

DESCRIPTION="Interface for doing mathematics and scientific computing"
HOMEPAGE="https://apps.kde.org/en/cantor https://edu.kde.org/cantor/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+analitza julia lua postscript python qalculate R"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} ) python? ( ${PYTHON_REQUIRED_USE} )"

# TODO Add Sage Mathematics Software backend (https://www.sagemath.org)
DEPEND="
	app-text/poppler[qt5]
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
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
	>=kde-frameworks/kpty-${KFMIN}:5
	>=kde-frameworks/ktexteditor-${KFMIN}:5
	>=kde-frameworks/ktextwidgets-${KFMIN}:5
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:5
	>=kde-frameworks/kxmlgui-${KFMIN}:5
	>=kde-frameworks/syntax-highlighting-${KFMIN}:5
	analitza? ( >=kde-apps/analitza-${PVCUT}:5 )
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
RDEPEND="${DEPEND}
	!analitza? ( !julia? ( !lua? ( !python? ( !qalculate? ( !R? (
		|| (
			sci-mathematics/maxima
			sci-mathematics/octave
		)
	) ) ) ) ) )
"

RESTRICT+=" test"

pkg_setup() {
	use lua && lua-single_pkg_setup
	use python && python-single-r1_pkg_setup
	ecm_pkg_setup
}

src_configure() {
	use julia && addpredict /proc/self/mem # bug 602894

	local mycmakeargs=(
		$(cmake_use_find_package analitza Analitza5)
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
	use python && mycmakeargs+=( -DPython3_EXECUTABLE="${PYTHON}" )
	ecm_src_configure
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "Optional dependencies:"
		optfeature "Maxima backend" sci-mathematics/maxima
		optfeature "Octave backend" sci-mathematics/octave
		optfeature "LaTeX support" virtual/latex-base
	fi
	ecm_pkg_postinst
}
