# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
LUA_COMPAT=( luajit )
PYTHON_COMPAT=( python3_{10..12} )
PVCUT=$(ver_cut 1-3)
KFMIN=6.7.0
QTMIN=6.7.2
inherit ecm gear.kde.org lua-single optfeature python-single-r1

DESCRIPTION="Interface for doing mathematics and scientific computing"
HOMEPAGE="https://apps.kde.org/cantor/"

LICENSE="GPL-2" # TODO: CHECK
SLOT="6"
KEYWORDS="~amd64 ~arm64"
IUSE="+analitza julia lua postscript python qalculate R webengine"

REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} ) python? ( ${PYTHON_REQUIRED_USE} )"
RESTRICT="test"

# TODO Add Sage Mathematics Software backend (https://www.sagemath.org)
DEPEND="
	>=app-text/poppler-23.12.0[qt6]
	dev-libs/libxml2:2
	dev-libs/libxslt
	>=dev-qt/qtbase-${QTMIN}:6[gui,widgets,xml]
	>=dev-qt/qtsvg-${QTMIN}:6
	>=kde-frameworks/karchive-${KFMIN}:6
	>=kde-frameworks/kcompletion-${KFMIN}:6
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kconfigwidgets-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/kcrash-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kiconthemes-${KFMIN}:6
	>=kde-frameworks/kio-${KFMIN}:6
	>=kde-frameworks/knewstuff-${KFMIN}:6
	>=kde-frameworks/kparts-${KFMIN}:6
	>=kde-frameworks/ktexteditor-${KFMIN}:6
	>=kde-frameworks/ktextwidgets-${KFMIN}:6
	>=kde-frameworks/kwidgetsaddons-${KFMIN}:6
	>=kde-frameworks/kxmlgui-${KFMIN}:6
	>=kde-frameworks/syntax-highlighting-${KFMIN}:6
	analitza? ( >=kde-apps/analitza-${PVCUT}:6 )
	julia? ( dev-lang/julia )
	lua? ( ${LUA_DEPS} )
	qalculate? (
		sci-libs/cln
		sci-libs/libqalculate:=
	)
	postscript? ( app-text/libspectre )
	python? (
		${PYTHON_DEPS}
		>=dev-qt/qtbase-${QTMIN}:6[dbus]
	)
	R? ( dev-lang/R )
	webengine? (
		>=dev-qt/qttools-${QTMIN}:6[assistant]
		>=dev-qt/qtwebengine-${QTMIN}:6[widgets]
	)
"
# !analitza?
RDEPEND="${DEPEND}
	!analitza? ( !julia? ( !lua? ( !python? ( !qalculate? ( !R? (
		|| (
			sci-mathematics/maxima
			sci-mathematics/octave
		)
	) ) ) ) ) )
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
		$(cmake_use_find_package analitza Analitza6)
		$(cmake_use_find_package julia Julia)
		$(cmake_use_find_package lua LuaJIT)
		-DUSE_LIBSPECTRE=$(usex postscript)
		$(cmake_use_find_package python Python3)
		$(cmake_use_find_package qalculate Qalculate)
		$(cmake_use_find_package R R)
		-DENABLE_EMBEDDED_DOCUMENTATION=$(usex webengine)
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
