# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit cmake-utils flag-o-matic python-single-r1 versionator

DESCRIPTION="Libs for the efficient manipulation of volumetric data"
HOMEPAGE="http://www.openvdb.org"
SRC_URI="https://github.com/dreamworksanimation/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/dracwyrm/gentoo-patches/raw/master/${PN}/${P}-patchset-01.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+abi3-compat doc python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="sys-libs/zlib:=
	>=dev-libs/boost-1.62:=[python?,${PYTHON_USEDEP}]
	media-libs/openexr:=
	media-libs/glfw:=
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXinerama
	x11-libs/libXcursor
	dev-libs/jemalloc
	>=dev-libs/c-blosc-1.5.0
	dev-libs/log4cplus
	python? (
		${PYTHON_DEPS}
		dev-python/numpy[${PYTHON_USEDEP}]
	)"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	dev-cpp/tbb
	doc? ( app-doc/doxygen[latex] )"

PATCHES=(
	"${WORKDIR}/0001-Change-hardcoded-paths-to-GNUInstallDirs-variables.patch"
	"${WORKDIR}/0002-Use-PkgConfig-to-find-IlmBase-and-OpenEXR.patch"
	"${WORKDIR}/0003-Boost-1.65-NumPy-support.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local myprefix="${EPREFIX}/usr/"

	# To stay in sync with Boost
	append-cxxflags -std=c++14

	local mycmakeargs=(
		-DOPENVDB_BUILD_UNITTESTS=OFF
		-DOPENVDB_BUILD_DOCS=$(usex doc)
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
		-DOPENVDB_BUILD_PYTHON_MODULE=$(usex python)
		-DOPENVDB_ENABLE_3_ABI_COMPATIBLE=$(usex abi3-compat)
		-DOPENVDB_ENABLE_RPATH=OFF
		-DUSE_GLFW3=ON
		-DBLOSC_LOCATION="${myprefix}"
		-DGLEW_LOCATION="${myprefix}"
		-DGLFW3_LOCATION="${myprefix}"
		-DTBB_LOCATION="${myprefix}"
	)

	use python && mycmakeargs+=( -DPYOENVDB_INSTALL_DIRECTORY=${python_get_sitedir} )

	cmake-utils_src_configure
}
