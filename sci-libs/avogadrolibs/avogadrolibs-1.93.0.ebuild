# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake-utils flag-o-matic

DESCRIPTION="Advanced molecule editor and visualizer 2 - libraries"
HOMEPAGE="https://www.openchemistry.org/ https://github.com/OpenChemistry/avogadrolibs"
SRC_URI="
	https://github.com/OpenChemistry/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz
	vtk? ( https://github.com/psavery/genXrdPattern/releases/download/1.0-static/linux64-genXrdPattern -> linux64-genXrdPattern-${P} )
"

SLOT="0"
LICENSE="BSD GPL-2+"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

# static-plugins needs to be enabled until upstream fixes
# https://github.com/OpenChemistry/avogadrolibs/issues/436
#IUSE="archive doc hdf5 qt5 static-plugins test vtk"
IUSE="archive doc hdf5 qt5 test vtk"
RESTRICT="!test? ( test )"

REQUIRED_USE="vtk? ( qt5 )"

# TODO: Not yet packaged:
# sci-libs/libmsym (https://github.com/mcodev31/libmsym)
# sci-libs/spglib (https://atztogo.github.io/spglib/)
RDEPEND="
	dev-libs/jsoncpp:=
	>=sci-chemistry/molequeue-0.7
	sci-libs/spglib
	archive? ( app-arch/libarchive )
	hdf5? ( sci-libs/hdf5:= )
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		media-libs/glew:0=
		virtual/opengl
	)
	vtk? ( sci-libs/vtk[qt5,views] )
"
DEPEND="${RDEPEND}
	dev-cpp/eigen:3
	qt5? ( dev-qt/linguist-tools:5 )
	test? ( dev-cpp/gtest )"

PATCHES=(
	# https://github.com/OpenChemistry/avogadrolibs/issues/449
	"${FILESDIR}"/${PN}-1.93.0-fix_AvogadroLibsConfig.patch
	"${FILESDIR}/"${PN}-1.91.0_pre20180406-bundled-genxrdpattern.patch
)

src_unpack() {
	default
	if use vtk; then
		cp "${DISTDIR}"/linux64-genXrdPattern-${P} "${WORKDIR}/genXrdPattern" || die
	fi
}

src_configure() {
	# -DBUILD_STATIC_PLUGINS=$(usex static-plugins)
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}/usr/share/doc/${PF}"
		-DUSE_PROTOCALL=OFF
		-DBUILD_GPL_PLUGINS=ON
		-DUSE_MOLEQUEUE=ON
		-DUSE_MMTF=OFF
		-DUSE_LIBMSYM=OFF
		-DUSE_SPGLIB=OFF
		-DUSE_PYTHON=OFF
		-DUSE_LIBARCHIVE=$(usex archive)
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DUSE_HDF5=$(usex hdf5)
		-DENABLE_TRANSLATIONS=$(usex qt5)
		-DUSE_OPENGL=$(usex qt5)
		-DUSE_QT=$(usex qt5)
		-DBUILD_STATIC_PLUGINS=ON
		-DENABLE_TESTING=$(usex test)
		-DUSE_VTK=$(usex vtk)
	)
	use vtk && mycmakeargs+=(
		-DBUNDLED_GENXRDPATTERN="${WORKDIR}/genXrdPattern"
	)

	cmake-utils_src_configure
}
