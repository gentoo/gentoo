# Copyright 2009-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake virtualx xdg

DESCRIPTION="Free EDA software to develop printed circuit boards"
HOMEPAGE="https://librepcb.org/"
SRC_URI="https://download.librepcb.org/releases/${PV}/${P}-source.zip"

S="${WORKDIR}/${PN}-${PV/_/-}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

IUSE="opencascade"

BDEPEND="
	app-arch/unzip
	dev-qt/qttools:6[linguist]"

RDEPEND="
	dev-cpp/muParser:=
	dev-libs/quazip:=[qt6(-)]
	dev-qt/qtbase[concurrent,gui,network,opengl,sql,sqlite,ssl,widgets]
	dev-qt/qtdeclarative:6
	dev-qt/qtsvg:6
	media-libs/libglvnd[X]
	opencascade? ( sci-libs/opencascade:= )
	sys-libs/zlib
	virtual/glu"

DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test ON OFF)
		-DUNBUNDLE_GTEST=ON
		-DUNBUNDLE_MUPARSER=ON
		-DUNBUNDLE_QUAZIP=ON
		-DUSE_OPENCASCADE=$(usex opencascade 1 0) )
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
