# Copyright 2009-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake virtualx xdg

DESCRIPTION="Free EDA software to develop printed circuit boards"
HOMEPAGE="https://librepcb.org/"
SRC_URI="https://download.librepcb.org/releases/${PV}/${P}-source.zip"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

IUSE="opencascade"

BDEPEND="
	app-arch/unzip
	dev-qt/linguist-tools:5"

RDEPEND="
	dev-cpp/muParser:=
	dev-libs/quazip:=[qt5(+)]
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtopengl:5
	dev-qt/qtprintsupport:5
	dev-qt/qtquickcontrols2:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	opencascade? ( sci-libs/opencascade:= )
	sys-libs/zlib
	virtual/opengl"

DEPEND="${RDEPEND}
	dev-qt/qttest:5"

S="${WORKDIR}/${PN}-${PV/_/-}"

src_configure() {
	local mycmakeargs+=(
		-DUSE_OPENCASCADE=$(usex opencascade 1 0)
		-DUNBUNDLE_QUAZIP=ON
		-DUNBUNDLE_MUPARSER=ON )
	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}"/tests/unittests || die
	# https://github.com/LibrePCB/LibrePCB/issues/516
	# virtx ./librepcb-unittests --gtest_filter=-SystemInfoTest.testGetUsername
	virtx ./librepcb-unittests --gtest_filter=-SystemInfoTest.testGetUsername:CategoryTreeModelTest.testSort:BoardPlaneFragmentsBuilderTest.testFragments:BoardGerberExportTest.test
}

pkg_postinst() {
	xdg_pkg_postinst

	ewarn
	ewarn "LibrePCB builds might not be exactly reproducible with e.g. -march={native,haswell,...}."
	ewarn "This can cause minor issues, see for example:"
	ewarn "https://github.com/LibrePCB/LibrePCB/issues/516"
	ewarn "For a completely reproducible build use: -march=x86-64."
	ewarn
}
