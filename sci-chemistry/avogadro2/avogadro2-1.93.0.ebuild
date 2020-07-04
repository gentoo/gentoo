# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PN=avogadroapp

inherit desktop cmake-utils xdg

DESCRIPTION="Advanced molecule editor and visualizer 2"
HOMEPAGE="https://www.openchemistry.org/"
SRC_URI="https://github.com/OpenChemistry/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

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

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	cmake-utils_src_prepare
	sed -e "/LICENSE/d" -i CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DAvogadro_ENABLE_RPC=$(usex rpc)
		-DENABLE_TESTING=$(usex test)
		-DUSE_VTK=$(usex vtk)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	for size in 64 128 256 512; do
		newicon -s "${size}" avogadro/icons/"${PN}"_"${size}".png "${PN}".png
	done
}
