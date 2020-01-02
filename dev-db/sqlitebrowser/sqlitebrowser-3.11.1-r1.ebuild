# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop xdg

DESCRIPTION="SQLite Database Browser"
HOMEPAGE="https://sqlitebrowser.org"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-qt/linguist-tools:5
	test? ( dev-qt/qttest:5 )
"
DEPEND="
	app-editors/qhexedit2
	dev-cpp/antlr-cpp:2
	dev-db/sqlite:3
	>=dev-libs/qcustomplot-2.0.0[qt5(+)]
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtwidgets:5
	>=x11-libs/qscintilla-2.10.1:=[qt5(+)]
	dev-qt/qtprintsupport:5
	dev-qt/qtxml:5

"
RDEPEND="${DEPEND}
	dev-qt/qtsvg:5
"

PATCHES=( "${FILESDIR}"/${PN}-3.11.1-unbundle.patch )

src_prepare() {
	cmake_src_prepare
	rm -r libs || die
	sed -i 's#"src/qhexedit.h"#<qhexedit.h>#' src/EditDialog.cpp || die
	#find libs/{antlr-2.7.7,qcustomplot-source,qscintilla} -delete || die

	sed -e "/^project/ s/\".*\"/sqlitebrowser/" -i CMakeLists.txt || die

	if ! use test; then
		sed -e "/find_package/ s/ Test//" -i CMakeLists.txt || die
		sed -e "/set/ s/ Qt5::Test//" -i CMakeLists.txt || die
	fi
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_TESTING=$(usex test)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	doicon images/sqlitebrowser.svg
}
