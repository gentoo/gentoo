# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_HANDBOOK="forceoptional"
KDE_TEST="forceoptional"
PYTHON_COMPAT=( python2_7 )
# FIXME: PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )
inherit kde5 python-r1

DESCRIPTION="Interface for doing mathematics and scientific computing"
HOMEPAGE="https://www.kde.org/applications/education/cantor https://edu.kde.org/cantor"
KEYWORDS="amd64 x86"
IUSE="analitza lua postscript python qalculate +R"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# TODO Add Sage Mathematics Software backend (http://www.sagemath.org)
# FIXME: $(python_gen_cond_dep 'dev-qt/qtdbus:5' 'python3*')
RDEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kcompletion)
	$(add_frameworks_dep kconfig)
	$(add_frameworks_dep kconfigwidgets)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep kcrash)
	$(add_frameworks_dep kdelibs4support)
	$(add_frameworks_dep ki18n)
	$(add_frameworks_dep kio)
	$(add_frameworks_dep knewstuff)
	$(add_frameworks_dep kparts)
	$(add_frameworks_dep kpty)
	$(add_frameworks_dep ktexteditor)
	$(add_frameworks_dep kwidgetsaddons)
	$(add_frameworks_dep kxmlgui)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	$(add_qt_dep qtxmlpatterns)
	analitza? ( $(add_kdeapps_dep analitza) )
	lua? ( dev-lang/luajit:2 )
	qalculate? (
		sci-libs/cln
		sci-libs/libqalculate
	)
	postscript? ( app-text/libspectre )
	python? ( ${PYTHON_DEPS} )
	R? ( dev-lang/R )
"
DEPEND="${RDEPEND}
	>=dev-cpp/eigen-2.0.3:2
"

RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${P}-tests.patch"
	"${FILESDIR}/${P}-qt56.patch"
)

pkg_setup() {
	use python && python_setup
	kde5_pkg_setup
}

src_prepare() {
	kde5_src_prepare

	# FIXME: shipped FindPythonLibs3.cmake does not work for Gentoo
	sed -e "/^find_package(PythonLibs3)/ s/^/#/" \
		-i src/backends/CMakeLists.txt || die

	if ! use test ; then
		sed -e "/add_subdirectory(test)/ s/^/#DONT/" \
			-i src/lib/CMakeLists.txt || die
		sed -e "/add_subdirectory(tests)/ s/^/#DONT/" \
			-i src/backends/python3/CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package analitza Analitza5)
		$(cmake-utils_use_find_package lua LuaJIT)
		$(cmake-utils_use_find_package postscript LibSpectre)
		$(cmake-utils_use_find_package python PythonLibs)
		$(cmake-utils_use_find_package qalculate Qalculate)
		$(cmake-utils_use_find_package R R)
	)
	kde5_src_configure
}

pkg_postinst() {
	kde5_pkg_postinst

	if ! use analitza && ! use lua && ! use python && ! use qalculate && ! use R; then
		echo
		ewarn "You have decided to build ${PN} with no backend."
		ewarn "To have this application functional, please do one of below:"
		ewarn "    # emerge -va1 '='${CATEGORY}/${P} with 'analitza', 'lua', 'python', 'qalculate' or 'R' USE flag enabled"
		ewarn "    # emerge -vaDu sci-mathematics/maxima"
		echo
	fi
}
