# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT=f414794a168712f72884cdcfba818def5f42e721
inherit cmake-utils

DESCRIPTION="Advanced molecule editor and visualizer 2 - libraries"
HOMEPAGE="https://www.openchemistry.org/"
SRC_URI="https://github.com/OpenChemistry/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD GPL-2+"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="archive doc hdf5 qt5 static-plugins test vtk"

# TODO: Not yet packaged:
# sci-libs/libmsym (https://github.com/mcodev31/libmsym)
# sci-libs/spglib (https://atztogo.github.io/spglib/)
RDEPEND="
	>=sci-chemistry/molequeue-0.7
	archive? ( app-arch/libarchive )
	hdf5? ( sci-libs/hdf5:= )
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		media-libs/glew:0=
	)
	vtk? ( sci-libs/vtk )
"
DEPEND="${RDEPEND}
	dev-cpp/eigen:3
	test? ( dev-cpp/gtest )"

S="${WORKDIR}/${PN}-${COMMIT}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.7.2-6464.patch
	"${FILESDIR}/"${P}-underlinking.patch
)

src_configure() {
	local mycmakeargs=(
		-DUSE_PROTOCALL=OFF
		-DBUILD_GPL_PLUGINS=ON
		-DUSE_MOLEQUEUE=ON
		-DUSE_LIBMSYM=OFF
		-DUSE_LIBSPG=OFF
		-DUSE_PYTHON=OFF
		-DUSE_LIBARCHIVE=$(usex archive)
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DUSE_HDF5=$(usex hdf5)
		-DUSE_OPENGL=$(usex qt5)
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
