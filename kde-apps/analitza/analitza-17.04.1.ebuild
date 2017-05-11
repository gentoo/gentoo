# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KDE_TEST="forceoptional-recursive"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="KDE library for mathematical features"
KEYWORDS="~amd64 ~x86"
IUSE="eigen"

DEPEND="
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	eigen? ( dev-cpp/eigen:3 )
"
RDEPEND="${DEPEND}"

src_prepare() {
	kde5_src_prepare

	if ! use test; then
		sed -i \
			-e "/add_subdirectory(examples)/ s/^/#DONT/" \
			analitzaplot/CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package eigen Eigen3)
	)

	kde5_src_configure
}
