# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PV_AVOGEN=1.98.0
MY_PV_CRYSTALS=1.98.0
MY_PV_FRAGMENTS=1.99.0
MY_PV_GENXRD=1.1
MY_PV_MOLECULES=1.98.0

DESCRIPTION="Advanced molecule editor and visualizer 2 - libraries"
HOMEPAGE="https://two.avogadro.cc/ https://www.openchemistry.org/"
SRC_URI="
	https://github.com/OpenChemistry/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz
	qt6? (
		https://github.com/OpenChemistry/avogenerators/archive/refs/tags/${MY_PV_AVOGEN}.tar.gz
			-> ${PN}-avogenerators-${MY_PV_AVOGEN}.tar.gz
		https://github.com/OpenChemistry/crystals/archive/refs/tags/${MY_PV_CRYSTALS}.tar.gz
			-> ${PN}-crystals-${MY_PV_CRYSTALS}.tar.gz
		https://github.com/OpenChemistry/fragments/archive/refs/tags/${MY_PV_FRAGMENTS}.tar.gz
			-> ${PN}-fragments-${MY_PV_FRAGMENTS}.tar.gz
		https://github.com/OpenChemistry/molecules/archive/refs/tags/${MY_PV_MOLECULES}.tar.gz
			-> ${PN}-molecules-${MY_PV_MOLECULES}.tar.gz
	)
	test? ( https://github.com/OpenChemistry/avogadrodata/archive/refs/tags/${PV}.tar.gz
		-> ${P}-data.tar.gz )
	vtk? ( https://github.com/psavery/genXrdPattern/releases/download/${MY_PV_GENXRD}-linux/linux64-genXrdPattern
		-> ${PN}-linux64-genXrdPattern-${MY_PV_GENXRD} )
"

LICENSE="BSD GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="archive doc hdf5 mmtf qt6 spglib test vtk"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	test? ( qt6 )
	vtk? ( qt6 )
"

# TODO: Not yet packaged:
# sci-libs/libmsym (https://github.com/mcodev31/libmsym)
RDEPEND="
	dev-cpp/nlohmann_json
	dev-libs/pugixml
	hdf5? ( sci-libs/hdf5:= )
	qt6? (
		>=sci-chemistry/openbabel-3.1.1_p20241221:=[json]
		dev-qt/qtbase:6[concurrent,gui,network,opengl,widgets]
		dev-qt/qtsvg:6
		media-libs/glew:0=
		virtual/opengl
		archive? ( app-arch/libarchive:= )
	)
	spglib? ( >=sci-libs/spglib-2.6.0:= )
	vtk? ( sci-libs/vtk:=[qt6,views] )
"
DEPEND="${RDEPEND}
	dev-cpp/eigen:3
	mmtf? ( dev-libs/mmtf-cpp )
"
BDEPEND="
	doc? ( app-text/doxygen )
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}/"${PN}-1.91.0_pre20180406-bundled-genxrdpattern.patch
	"${FILESDIR}/"${PN}-1.100-tests.patch
	# https://github.com/OpenChemistry/avogadrolibs/issues/1633
	"${FILESDIR}/"${PN}-1.100-fix-openbabel3.patch
)

# Static binary (requires ObjCryst++ to build otherwise)
QA_FLAGS_IGNORED="usr/bin/genXrdPattern"

src_unpack() {
	default

	rm -rf thirdparty/{nlohmann,pugixml} || die

	if use vtk; then
		cp "${DISTDIR}"/${PN}-linux64-genXrdPattern-${MY_PV_GENXRD} "${WORKDIR}/genXrdPattern" || die
	fi

	if use qt6; then
		# hardcoded assumptions in
		# avogadro/qtplugins/insertfragment/CMakeLists.txt
		mv crystals-${MY_PV_CRYSTALS} crystals || die
		mv molecules-${MY_PV_MOLECULES} molecules || die
		# avogadro/qtplugins/quantuminput/CMakeLists.txt
		mv avogenerators-${MY_PV_AVOGEN} avogadrogenerators || die
		# avogadro/qtplugins/templatetool/CMakeLists.txt
		mv fragments-${MY_PV_FRAGMENTS} fragments || die
	fi

	if use test; then
		mv avogadrodata-${PV} avogadrodata || die
	fi
}

src_prepare() {
	# fix default value for BABEL_LIBDIR
	sed -i -e "s:/../lib/openbabel:/../$(get_libdir)/openbabel:g" \
		avogadro/qtplugins/forcefield/obenergy.cpp \
		avogadro/qtplugins/forcefield/obmmenergy.cpp \
		avogadro/qtplugins/openbabel/obprocess.cpp || die

	if use doc; then
		doxygen -u docs/doxyfile.in 2>/dev/null || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DUSE_EXTERNAL_NLOHMANN=ON
		-DUSE_EXTERNAL_PUGIXML=ON
		-DUSE_LIBARCHIVE=$(usex archive $(usex qt6))
		-DBUILD_DOCUMENTATION=$(usex doc)
		-DUSE_HDF5=$(usex hdf5)
		-DUSE_MMTF=$(usex mmtf)
		-DUSE_OPENGL=$(usex qt6)
		-DUSE_QT=$(usex qt6)
		-DUSE_SPGLIB=$(usex spglib)
		-DENABLE_TESTING=$(usex test)
		-DUSE_VTK=$(usex vtk)
		# disabled libraries
		-DUSE_PYTHON=OFF
		-DUSE_LIBMSYM=OFF
	)

	use qt6 && mycmakeargs+=(
		-DBUILD_GPL_PLUGINS=ON
		-DQT_VERSION=6
	)

	use vtk && mycmakeargs+=(
		-DBUNDLED_GENXRDPATTERN="${WORKDIR}/genXrdPattern"
		-DUSE_SYSTEM_GENXRDPATTERN=OFF
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	use doc && cmake_build documentation
}

src_test() {
	local -x LD_LIBRARY_PATH="${BUILD_DIR}/lib"
	cmake_src_test
}

src_install() {
	if use doc; then
		local DOCS+=( "${BUILD_DIR}"/docs/xml )
		local HTML_DOCS=( "${BUILD_DIR}"/docs/html/. )
		docompress -x /usr/share/doc/${PF}/xml
	fi

	cmake_src_install

	# remove CONTRIBUTING, LICENSE and duplicate README
	rm -r "${ED}/usr/share/doc/${PF}/avogadrolibs" || die
}
