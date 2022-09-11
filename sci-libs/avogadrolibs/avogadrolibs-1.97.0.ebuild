# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Advanced molecule editor and visualizer 2 - libraries"
HOMEPAGE="https://www.openchemistry.org/ https://github.com/OpenChemistry/avogadrolibs"
SRC_URI="
	https://github.com/OpenChemistry/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/OpenChemistry/molecules/archive/refs/tags/1.0.0.tar.gz -> ${PN}-molecules-1.0.0.tar.gz
	https://github.com/OpenChemistry/crystals/archive/refs/tags/1.0.1.tar.gz -> ${PN}-crystals-1.0.1.tar.gz
	vtk? ( https://github.com/psavery/genXrdPattern/releases/download/1.0-static/linux64-genXrdPattern -> linux64-genXrdPattern-${P} )"

LICENSE="BSD GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="archive doc hdf5 qt5 test vtk"
RESTRICT="!test? ( test )"
REQUIRED_USE="vtk? ( qt5 )"

# TODO: Not yet packaged:
# sci-libs/libmsym (https://github.com/mcodev31/libmsym)
RDEPEND="
	>=sci-chemistry/molequeue-0.7
	archive? ( app-arch/libarchive:= )
	hdf5? ( sci-libs/hdf5:= )
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		media-libs/glew:0=
		virtual/opengl
	)
	vtk? ( sci-libs/vtk[qt5,views] )"
DEPEND="${RDEPEND}
	dev-cpp/eigen:3
	test? ( dev-cpp/gtest )"
BDEPEND="
	doc? ( app-doc/doxygen[dot] )
	qt5? ( dev-qt/linguist-tools:5 )"

PATCHES=(
	"${FILESDIR}/"${PN}-1.91.0_pre20180406-bundled-genxrdpattern.patch
	"${FILESDIR}/"${PN}-1.95.1-tests.patch
)

src_unpack() {
	default

	if use vtk; then
		cp "${DISTDIR}"/linux64-genXrdPattern-${P} "${WORKDIR}/genXrdPattern" || die
	fi

	# hardcoded assumptions in
	# avogadro/qtplugins/insertfragment/CMakeLists.txt
	mv crystals-1.0.1 crystals || die
	mv molecules-1.0.0 molecules || die
}

src_configure() {
	local mycmakeargs=(
		-DUSE_LIBARCHIVE=$(usex archive)
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DUSE_HDF5=$(usex hdf5)
		-DENABLE_TRANSLATIONS=$(usex qt5)
		-DUSE_OPENGL=$(usex qt5)
		-DUSE_QT=$(usex qt5)
		-DENABLE_TESTING=$(usex test)
		-DUSE_VTK=$(usex vtk)
		# disabled libraries
		-DUSE_PYTHON=OFF
		-DUSE_PROTOCALL=OFF
		-DUSE_MMTF=OFF
		-DUSE_LIBMSYM=OFF
		# find_package(Spglib) completely broken
		-DUSE_SPGLIB=OFF
	)
	use qt5 && mycmakeargs+=(
		-DBUILD_GPL_PLUGINS=ON
		-DBUILD_STATIC_PLUGINS=ON
		-DOpenGL_GL_PREFERENCE=GLVND
	)
	use vtk && mycmakeargs+=(
		-DBUNDLED_GENXRDPATTERN="${WORKDIR}/genXrdPattern"
	)

	cmake_src_configure
}
