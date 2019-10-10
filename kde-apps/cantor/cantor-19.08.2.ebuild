# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_HANDBOOK="forceoptional"
KDE_TEST="forceoptional"
PYTHON_COMPAT=( python3_{6,7} )
inherit kde5 python-single-r1

DESCRIPTION="Interface for doing mathematics and scientific computing"
HOMEPAGE="https://kde.org/applications/education/cantor https://edu.kde.org/cantor/"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+analitza julia lua markdown postscript python qalculate R"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# TODO Add Sage Mathematics Software backend (http://www.sagemath.org)
DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kiconthemes)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kpty)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep ktextwidgets)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_frameworks_dep syntax-highlighting)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtprintsupport)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	$(add_qt_dep qtxmlpatterns)
	analitza? ( $(add_kdeapps_dep analitza) )
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
		$(add_qt_dep qtdbus)
	)
	R? ( dev-lang/R )
"
RDEPEND="${DEPEND}"

RESTRICT+=" test"

pkg_pretend() {
	kde5_pkg_pretend

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
	kde5_pkg_setup
}

src_configure() {
	use julia && addpredict /proc/self/mem # bug 602894

	local mycmakeargs=(
		-DCMAKE_DISABLE_FIND_PACKAGE_PythonLibs=ON
		$(cmake-utils_use_find_package analitza Analitza5)
		$(cmake-utils_use_find_package julia Julia)
		$(cmake-utils_use_find_package lua LuaJIT)
		$(cmake-utils_use_find_package markdown Discount)
		$(cmake-utils_use_find_package postscript LibSpectre)
		$(cmake-utils_use_find_package python PythonLibs3)
		$(cmake-utils_use_find_package qalculate Qalculate)
		$(cmake-utils_use_find_package R R)
	)
	kde5_src_configure
}
