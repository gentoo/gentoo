# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

ECM_TEST="forceoptional"
QTMIN=5.12.3
inherit ecm kde.org

DESCRIPTION="API to manage the serial connection between the computer and 3D Printers"
SRC_URI="mirror://kde/stable/${PN}/${PV}/${P}.tar.xz"
HOMEPAGE="https://atelier.kde.org/"

LICENSE="|| ( LGPL-2.1+ LGPL-3 ) gui? ( GPL-3+ )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc gui test"

BDEPEND="
	>=dev-qt/linguist-tools-${QTMIN}:5
	doc? ( app-doc/doxygen[dot] )
"
DEPEND="
	>=dev-qt/qtserialport-${QTMIN}:5
	gui? (
		>=dev-qt/qtcharts-${QTMIN}:5
		>=dev-qt/qtgui-${QTMIN}:5
		>=dev-qt/qtwidgets-${QTMIN}:5
	)
"
RDEPEND="${DEPEND}"

src_prepare() {
	ecm_src_prepare

	sed -e "s/${PN}/${PF}/" -i doc/CMakeLists.txt || die

	use gui || ecm_punt_bogus_dep Qt5 Charts
	use test || cmake_comment_add_subdirectory unittests
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS=$(usex doc)
		-DBUILD_TEST_GUI=$(usex gui)
	)

	ecm_src_configure
}
