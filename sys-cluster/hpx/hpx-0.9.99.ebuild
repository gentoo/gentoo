# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MAKEFILE_GENERATOR="ninja"
PYTHON_COMPAT=( python{2_7,3_4} )

if [ ${PV} == 9999 ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/STEllAR-GROUP/hpx.git"
else
	SRC_URI="http://stellar.cct.lsu.edu/files/${PN}_${PV}.tar.gz"
	KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
	S="${WORKDIR}/${PN}_${PV}"
fi

inherit cmake-utils fortran-2 multilib python-any-r1

DESCRIPTION="C++ runtime system for parallel and distributed applications"
HOMEPAGE="http://stellar.cct.lsu.edu/tag/hpx/"

SLOT="0"
LICENSE="Boost-1.0"
IUSE="doc examples jemalloc papi +perftools tbb test"

RDEPEND="
	tbb? ( dev-cpp/tbb )
	>=dev-libs/boost-1.49
	papi? ( dev-libs/papi )
	perftools? ( >=dev-util/google-perftools-1.7.1 )
	>=sys-apps/hwloc-1.8
	>=sys-libs/libunwind-1
	sys-libs/zlib
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( ${PYTHON_DEPS} )
	doc? ( >=dev-libs/boost-1.56.0-r1:=[tools] )
"
REQUIRED_USE="
	jemalloc? ( !perftools !tbb )
	perftools? ( !jemalloc !tbb )
	tbb? ( !jemalloc !perftools )
	"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	CMAKE_BUILD_TYPE=Release
	local mycmakeargs=(
		-DHPX_BUILD_EXAMPLES=OFF
		-DHPX_MALLOC=system
		-DLIB=$(get_libdir)
		-Dcmake_dir=cmake
		-DHPX_BUILD_DOCUMENTATION=$(usex doc)
		-DHPX_JEMALLOC=$(usex jemalloc)
		-DBUILD_TESTING=$(usex test)
		-DHPX_GOOGLE_PERFTOOLS=$(usex perftools)
		-DHPX_PAPI=$(usex papi)
	)

	use perftools && mycmakeargs+=( -DHPX_MALLOC=tcmalloc )
	use jemalloc && mycmakeargs+=( -DHPX_MALLOC=jemalloc )
	use tbb && mycmakeargs+=( -DHPX_MALLOC=tbbmalloc )

	cmake-utils_src_configure
}

src_test() {
	# avoid over-suscribing
	cmake-utils_src_make -j1 tests
}

src_install() {
	cmake-utils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
