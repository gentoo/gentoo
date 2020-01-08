# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit cmake-utils flag-o-matic python-single-r1

DESCRIPTION="Libs for the efficient manipulation of volumetric data"
HOMEPAGE="https://www.openvdb.org"
SRC_URI="https://github.com/dreamworksanimation/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~dracwyrm/patches/${P}-patchset-02.tar.xz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="+abi3-compat doc python test"
RESTRICT="!test? ( test )"
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
	)"

DEPEND="${RDEPEND}
	dev-cpp/tbb
	virtual/pkgconfig
	doc? ( app-doc/doxygen[latex] )
	test? ( dev-util/cppunit )"

PATCHES=(
	"${WORKDIR}/${P}-patchset-02/0001-use-gnuinstalldirs.patch"
	"${WORKDIR}/${P}-patchset-02/0002-use-pkgconfig-for-ilmbase-and-openexr.patch"
	"${WORKDIR}/${P}-patchset-02/0003-boost-1.65-numpy-support.patch"
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
		-DGLFW3_LOCATION="${myprefix}"
		-DOPENVDB_BUILD_DOCS=$(usex doc)
		-DOPENVDB_BUILD_PYTHON_MODULE=$(usex python)
		-DOPENVDB_BUILD_UNITTESTS=$(usex test)
		-DOPENVDB_ENABLE_3_ABI_COMPATIBLE=$(usex abi3-compat)
		-DOPENVDB_ENABLE_RPATH=OFF
		-DTBB_LOCATION="${myprefix}"
		-DUSE_GLFW3=ON
	)

	use python && mycmakeargs+=( -DPYOPENVDB_INSTALL_DIRECTORY="$(python_get_sitedir)" )
	use test && mycmakeargs+=( -DCPPUNIT_LOCATION="${myprefix}" )

	cmake-utils_src_configure
}
