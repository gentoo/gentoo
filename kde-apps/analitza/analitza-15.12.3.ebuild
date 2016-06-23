# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_TEST="forceoptional"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="KDE library for mathematical features"
KEYWORDS="amd64 x86"
IUSE="eigen opengl"

DEPEND="
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	eigen? ( dev-cpp/eigen:3 )
	opengl? (
		$(add_qt_dep qtopengl)
		virtual/opengl
	)
"
RDEPEND="${DEPEND}"

src_prepare() {
	# Nothing is installed
	sed -i \
		-e "/add_subdirectory(examples)/ s/^/#DONT/" \
		analitzaplot/CMakeLists.txt || die

	if ! use test ; then
		sed -i \
			-e "/add_subdirectory(tests)/ s/^/#DONT/" \
			analitza{,gui,plot}/CMakeLists.txt || die
	fi

	kde5_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package eigen Eigen3)
		$(cmake-utils_use_find_package opengl OpenGL)
	)

	kde5_src_configure
}
