# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit cmake-utils flag-o-matic python-single-r1

DESCRIPTION="Libs for the efficient manipulation of volumetric data"
HOMEPAGE="http://www.openvdb.org"
SRC_URI="https://github.com/dreamworksanimation/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/dracwyrm/gentoo-patches/raw/master/${PN}/${P}-patchset-01.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+abi3-compat doc python"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/boost-1.62:=[python?,${PYTHON_USEDEP}]
	>=dev-libs/c-blosc-1.5.0
	dev-libs/jemalloc
	dev-libs/log4cplus
	media-libs/glfw:=
	media-libs/openexr:=
	sys-libs/zlib:=
	x11-libs/libXcursor
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	python? (
		${PYTHON_DEPS}
		dev-python/numpy[${PYTHON_USEDEP}]
	)
"

DEPEND="${RDEPEND}
	dev-cpp/tbb
	virtual/pkgconfig
	doc? ( app-doc/doxygen[latex] )
"

PATCHES=(
	"${WORKDIR}/0001-Change-hardcoded-paths-to-GNUInstallDirs-variables.patch"
	"${WORKDIR}/0002-Use-PkgConfig-to-find-IlmBase-and-OpenEXR.patch"
	"${WORKDIR}/0003-Boost-1.65-NumPy-support.patch"
	"${FILESDIR}/${P}-findboost-fix.patch"
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local myprefix="${EPREFIX}/usr/"

	# To stay in sync with Boost
	append-cxxflags -std=c++14

	local mycmakeargs=(
		-DBLOSC_LOCATION="${myprefix}"
		-DCMAKE_INSTALL_DOCDIR="share/doc/${PF}"
		-DGLEW_LOCATION="${myprefix}"
		-DGLFW3_LOCATION="${myprefix}"
		-DOPENVDB_BUILD_DOCS=$(usex doc)
		-DOPENVDB_BUILD_PYTHON_MODULE=$(usex python)
		-DOPENVDB_BUILD_UNITTESTS=OFF
		-DOPENVDB_ENABLE_3_ABI_COMPATIBLE=$(usex abi3-compat)
		-DOPENVDB_ENABLE_RPATH=OFF
		-DTBB_LOCATION="${myprefix}"
		-DUSE_GLFW3=ON
	)

	use python && mycmakeargs+=( -DPYOENVDB_INSTALL_DIRECTORY=${python_get_sitedir} )

	cmake-utils_src_configure
}
