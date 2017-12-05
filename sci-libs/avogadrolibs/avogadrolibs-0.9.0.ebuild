# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Advanced molecule editor and visualizer 2 - libraries"
HOMEPAGE="http://www.openchemistry.org/"
SRC_URI="https://github.com/OpenChemistry/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD GPL-2+"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc hdf5 opengl qt5 static-plugins test vtk"

REQUIRED_USE="qt5? ( opengl )"

RDEPEND="
	>=sci-chemistry/molequeue-0.7
	sci-libs/chemkit
	hdf5? ( sci-libs/hdf5:= )
	opengl? (
		dev-qt/qtopengl:5
		media-libs/glew
	)
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
	)
	vtk? ( sci-libs/vtk )
"
DEPEND="${DEPEND}
	dev-cpp/eigen:3
	test? ( dev-cpp/gtest )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.2-6464.patch
	"${FILESDIR}/"${PN}-0.8.0-underlinking.patch
)

src_configure() {
	local mycmakeargs=(
		-DUSE_PROTOCALL=OFF
		-DBUILD_GPL_PLUGINS=ON
		-DUSE_MOLEQUEUE=ON
		-DUSE_HDF5=$(usex hdf5)
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DUSE_OPENGL=$(usex opengl)
		-DUSE_QT=$(usex qt5)
		-DBUILD_STATIC_PLUGINS=$(usex static-plugins)
		-DENABLE_TESTING=$(usex test)
		-DUSE_VTK=$(usex vtk)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# TODO: bundles jsoncpp
	rm "${ED%/}"/usr/lib64/libjsoncpp.a || die
}
