# Copyright 2009-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake virtualx xdg

DESCRIPTION="Free EDA software to develop printed circuit boards"
HOMEPAGE="https://librepcb.org/"
SRC_URI="https://download.librepcb.org/releases/${PV}/${P}-source.zip"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	app-arch/unzip
	dev-qt/linguist-tools:5"

RDEPEND="
	dev-cpp/muParser:=
	dev-libs/quazip:=[qt5(+)]
	dev-qt/qtcore:5
	dev-qt/qtconcurrent:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	sys-libs/zlib"

DEPEND="${RDEPEND}
	dev-qt/qttest:5"

PATCHES=( "${FILESDIR}"/${P}-muparser-fix.patch )

src_configure() {
	local mycmakeargs+=(
		-DUNBUNDLE_QUAZIP=ON
		-DUNBUNDLE_MUPARSER=ON )
	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}"/tests/unittests || die
	virtx ./librepcb-unittests --gtest_filter=-SystemInfoTest.testGetUsername
}
