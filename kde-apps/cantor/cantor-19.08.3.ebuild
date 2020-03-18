# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_HANDBOOK="forceoptional"
ECM_TEST="forceoptional"
PYTHON_COMPAT=( python3_{6,7} )
PVCUT=$(ver_cut 1-3)
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm kde.org python-single-r1

DESCRIPTION="Interface for doing mathematics and scientific computing"
HOMEPAGE="https://kde.org/applications/education/cantor https://edu.kde.org/cantor/"
LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="amd64 arm64 x86"
IUSE="+analitza julia lua markdown postscript python qalculate R"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# TODO Add Sage Mathematics Software backend (http://www.sagemath.org)
DEPEND="
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
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtprintsupport-${QTMIN}:5
	>=dev-qt/qtsvg-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	>=dev-qt/qtxmlpatterns-${QTMIN}:5
	analitza? ( >=kde-apps/analitza-${PVCUT}:5 )
	julia? ( dev-lang/julia )
	lua? ( dev-lang/luajit:2 )
	markdown? ( >=app-text/discount-2.2.2 )
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
RDEPEND="${DEPEND}"

RESTRICT+=" test"

pkg_pretend() {
	ecm_pkg_pretend

	if ! has_version sci-mathematics/maxima && ! has_version sci-mathematics/octave && \
		! use analitza && ! use julia && ! use lua && ! use python && ! use qalculate && ! use R; then
		elog "You have decided to build ${PN} with no backend."
		elog "To have this application functional, please enable one of the backends via USE flag:"
		elog "    analitza, lua, python, qalculate, R"
		elog "Alternatively, install one of these:"
		elog "    # emerge sci-mathematics/maxima (bug #619534)"
		elog "    # emerge sci-mathematics/octave"
		elog "Experimental available USE flag:"
		elog "    julia (not stable, bug #613576)"
		elog
	fi

	if ! has_version virtual/latex-base; then
		elog "For LaTeX support:"
		elog "    # emerge virtual/latex-base"
	fi
}

pkg_setup() {
	use python && python-single-r1_pkg_setup
	ecm_pkg_setup
}

src_configure() {
	use julia && addpredict /proc/self/mem # bug 602894

	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_PythonLibs=ON
		$(cmake_use_find_package analitza Analitza5)
		$(cmake_use_find_package julia Julia)
		$(cmake_use_find_package lua LuaJIT)
		$(cmake_use_find_package markdown Discount)
		$(cmake_use_find_package postscript LibSpectre)
		$(cmake_use_find_package python PythonLibs3)
		$(cmake_use_find_package qalculate Qalculate)
		$(cmake_use_find_package R R)
	)
	ecm_src_configure
}
