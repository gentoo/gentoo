# Copyright 2009-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Free EDA software to develop printed circuit boards"
HOMEPAGE="https://librepcb.org/"
SRC_URI="https://download.librepcb.org/releases/${PV}/${P}-source.zip"
S="${WORKDIR}/${PN}-${PV/_/-}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="opencascade test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-cpp/muParser:=
	>=dev-libs/quazip-1.3-r2:=[qt6(+)]
	dev-qt/qtbase:6[concurrent,gui,network,opengl,sql,sqlite,ssl,widgets]
	dev-qt/qtdeclarative:6
	dev-qt/qtsvg:6
	media-libs/libglvnd[X]
	sys-libs/zlib
	virtual/glu
	opencascade? ( sci-libs/opencascade:= )"

DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )"

BDEPEND="
	app-arch/unzip
	dev-qt/qttools:6[linguist]"

src_configure() {
	local mycmakeargs=(
		-DQT_MAJOR_VERSION=6
		-DUNBUNDLE_GTEST=ON
		-DUNBUNDLE_MUPARSER=ON
		-DUNBUNDLE_QUAZIP=ON
		-DUSE_OPENCASCADE=$(usex opencascade 1 0)
		-DBUILD_TESTS=$(usex test ON OFF)
	)
	cmake_src_configure
}

src_test() {
	local -x QT_QPA_PLATFORM=offscreen
	cd "${BUILD_DIR}"/tests/unittests || die
	# https://github.com/LibrePCB/LibrePCB/issues/516
	./librepcb-unittests --gtest_filter=-SystemInfoTest.testGetUsername:CategoryTreeModelTest.testSort:BoardPlaneFragmentsBuilderTest.testFragments:BoardGerberExportTest.test
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
