# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

MY_PN=avogadroapp
MY_P=${MY_PN}-${PV}

DESCRIPTION="Advanced molecule editor and visualizer 2"
HOMEPAGE="http://www.openchemistry.org/"
SRC_URI="mirror://sourceforge/project/avogadro/avogadro2/${PV}/${MY_P}.tar.gz"

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
	sci-libs/hdf5
	rpc? ( sci-chemistry/molequeue )
"
DEPEND="${DEPEND}
	>=dev-cpp/eigen-3.2.0-r1
	test? ( dev-qt/qttest:5 )"

RESTRICT=test

S="${WORKDIR}"/${MY_P}

PATCHES=(
	"${FILESDIR}"/${P}-desktop.patch
	"${FILESDIR}"/${P}-vtk.patch
)

src_prepare() {
	sed '/COPYING/d' -i CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_build doc DOCUMENTATION)
		$(cmake-utils_use rpc Avogadro_ENABLE_RPC)
		$(cmake-utils_use_enable test TESTING)
		$(cmake-utils_use_use vtk)
		)
	cmake-utils_src_configure
}
