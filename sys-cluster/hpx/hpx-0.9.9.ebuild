# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit cmake-utils fortran-2 multilib python-single-r1 versionator

MY_PV="$(replace_version_separator _ -)"

SRC_URI="https://github.com/STEllAR-GROUP/hpx/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/${PN}-${MY_PV}"

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
	test? ( dev-lang/python )
	doc? ( >=dev-libs/boost-1.56.0-r1[tools] )
"
REQUIRED_USE="test? ( ${PYTHON_REQUIRED_USE} )
	jemalloc? ( !perftools !tbb )
	perftools? ( !jemalloc !tbb )
	tbb? ( !jemalloc !perftools )
	"

pkg_setup() {
	use test && python-single-r1_pkg_setup
}

src_configure() {
	CMAKE_BUILD_TYPE=Release
	local mycmakeargs=(
		-DHPX_BUILD_EXAMPLES=OFF
		-DHPX_MALLOC=system
		-DLIB=$(get_libdir)
		-Dcmake_dir=cmake
		$(cmake-utils_use doc HPX_BUILD_DOCUMENTATION)
		$(cmake-utils_use jemalloc HPX_JEMALLOC)
		$(cmake-utils_use test BUILD_TESTING)
		$(cmake-utils_use perftools HPX_GOOGLE_PERFTOOLS)
		$(cmake-utils_use papi HPX_PAPI)
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
