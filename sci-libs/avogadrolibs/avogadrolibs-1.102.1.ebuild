# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake dot-a python-single-r1

MY_PV_AVOGEN=${PV}
MY_PV_CRYSTALS=${PV}
MY_PV_FRAGMENTS=${PV}
MY_PV_MOLECULES=${PV}

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
"

LICENSE="BSD GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="archive doc hdf5 python qt6 spglib static-libs test"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( qt6 )
"

# TODO: Not yet packaged:
# sci-libs/libmsym (https://github.com/mcodev31/libmsym)
RDEPEND="
	dev-cpp/eigen:=
	dev-cpp/nlohmann_json
	dev-libs/pugixml
	hdf5? ( sci-libs/hdf5:= )
	python? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep 'dev-python/pybind11[${PYTHON_USEDEP}]')
	)
	qt6? (
		dev-qt/qtbase:6[concurrent,gui,network,opengl,widgets]
		dev-qt/qtsvg:6
		media-libs/glew:0=
		>=sci-chemistry/openbabel-3.1.1_p20241221:=[json]
		sci-libs/jkqtplotter:=
		virtual/opengl
		archive? ( app-arch/libarchive:= )
	)
	spglib? ( >=sci-libs/spglib-2.6.0:= )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	doc? ( app-text/doxygen )
	test? ( dev-cpp/gtest )
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_unpack() {
	default

	rm -rf thirdparty/{nlohmann,pugixml} || die

	if use qt6; then
		# hardcoded assumptions in
		# avogadro/qtplugins/insertfragment/CMakeLists.txt
		mv crystals-${MY_PV_CRYSTALS} crystals || die
		mv molecules-${MY_PV_MOLECULES} molecules || die
		# avogadro/qtplugins/quantuminput/CMakeLists.txt
		mv avogenerators-${MY_PV_AVOGEN} avogenerators || die
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

	# avoid cmake_min warning w/ this unused file
	rm thirdparty/tinycolormap/CMakeLists.txt || die

	if use doc; then
		doxygen -u docs/doxyfile.in 2>/dev/null || die
	fi

	# restore user-LDFLAGS
	if use python; then
		sed -e 's:CMAKE_MODULE_LINKER_FLAGS "":CMAKE_MODULE_LINKER_FLAGS "'"${LDFLAGS}"'":' \
			-i "${S}"/python/CMakeLists.txt || die
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
		# https://github.com/OpenChemistry/avogadrolibs/issues/2200
		-DUSE_MMTF=OFF
		-DUSE_OPENGL=$(usex qt6)
		-DUSE_PYTHON=$(usex python)
		-DUSE_QT=$(usex qt6)
		-DUSE_SPGLIB=$(usex spglib)
		-DENABLE_TESTING=$(usex test)
		# disabled libraries
		-DUSE_LIBMSYM=OFF
	)

	if use qt6; then
		mycmakeargs+=(
			-DBUILD_GPL_PLUGINS=ON
			-DBUILD_STATIC_PLUGINS=$(usex static-libs)
			-DQT_VERSION=6
		)
		# python interpreter for qtplugins, but it can be changed in settings and pixi may install another version too ...
		# given that, not added to REQUIRED_USE
		use python && mycmakeargs+=( -DPython3_EXECUTABLE="${PYTHON}" )

		# even w/o static-libs due to libgwavi.a, required for avogadro2
		lto-guarantee-fat
	fi

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

	if use python; then
		python_fix_shebang "${ED}"
		python_optimize "${ED}"
	fi

	# always strip due to libgwavi.a
	use qt6 && strip-lto-bytecode "${ED}"

	# remove CONTRIBUTING, LICENSE and duplicate README
	rm -r "${ED}/usr/share/doc/${PF}/avogadrolibs" || die
}
