# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

MY_PN=avogadroapp
MY_P=${MY_PN}-${PV}

DESCRIPTION="Advanced molecule editor and visualizer 2"
HOMEPAGE="http://www.openchemistry.org/"
SRC_URI="https://github.com/OpenChemistry/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD GPL-2+"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc rpc test vtk"

RDEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtopengl:5
	dev-qt/qtwidgets:5
	~sci-libs/avogadrolibs-${PV}[qt5,opengl]
	sci-libs/hdf5:=
	rpc? ( sci-chemistry/molequeue )
"
DEPEND="${DEPEND}
	dev-cpp/eigen:3
	test? ( dev-qt/qttest:5 )
"

RESTRICT=test

S="${WORKDIR}"/${MY_P}

src_prepare() {
	cmake-utils_src_prepare
	sed '/COPYING/d' -i CMakeLists.txt || die
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
