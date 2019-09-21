# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_TEST="forceoptional"
inherit kde5

DESCRIPTION="API to manage the serial connection between the computer and 3D Printers"
SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
HOMEPAGE="https://atelier.kde.org/"

LICENSE="|| ( LGPL-2.1+ LGPL-3 ) gui? ( GPL-3+ )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc gui test"

BDEPEND="
	$(add_qt_dep linguist-tools)
	doc? ( app-doc/doxygen[dot] )
"
DEPEND="
	$(add_qt_dep qtserialport)
	gui? (
		$(add_qt_dep qtcharts)
		$(add_qt_dep qtgui)
		$(add_qt_dep qtwidgets)
	)
"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake-utils_src_prepare

	sed -e "s/${PN}/${PF}/" -i doc/CMakeLists.txt || die

	use gui || punt_bogus_dep Qt5 Charts
	use test || cmake_comment_add_subdirectory unittests
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS=$(usex doc)
		-DBUILD_TEST_GUI=$(usex gui)
	)

	cmake-utils_src_configure
}
