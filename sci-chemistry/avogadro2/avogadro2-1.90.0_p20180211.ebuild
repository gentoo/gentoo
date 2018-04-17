# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN=avogadroapp
COMMIT=d5e1f827be7e9d1cc6755fd68a2b42b0b1d2ec32
inherit cmake-utils xdg-utils

DESCRIPTION="Advanced molecule editor and visualizer 2"
HOMEPAGE="https://www.openchemistry.org/"
SRC_URI="https://github.com/OpenChemistry/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD GPL-2+"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc rpc test vtk"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	>=sci-libs/avogadrolibs-${PV}[qt5,vtk?]
	sci-libs/hdf5:=
	rpc? ( sci-chemistry/molequeue )
"
DEPEND="${DEPEND}
	dev-cpp/eigen:3
	test? ( dev-qt/qttest:5 )
"

RESTRICT="test"

S="${WORKDIR}/${MY_PN}-${COMMIT}"

PATCHES=( "${FILESDIR}/${P}-qt-5.11b3.patch" )

src_prepare() {
	cmake-utils_src_prepare
	sed -e "/LICENSE/d" -i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DAvogadro_ENABLE_RPC=$(usex rpc)
		-DENABLE_TESTING=$(usex test)
		-DUSE_VTK=$(usex vtk)
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
