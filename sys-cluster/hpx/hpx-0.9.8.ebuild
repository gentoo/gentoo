# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/hpx/hpx-0.9.8.ebuild,v 1.2 2015/04/08 18:25:44 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

SRC_URI="http://stellar.cct.lsu.edu/files/${PN}_${PV}.7z"
KEYWORDS="~amd64 ~x86"
S="${WORKDIR}/${PN}_${PV}"

inherit cmake-utils fortran-2 multilib python-single-r1

DESCRIPTION="C++ runtime system for parallel and distributed applications"
HOMEPAGE="http://stellar.cct.lsu.edu/tag/hpx/"

SLOT="0"
LICENSE="Boost-1.0"
IUSE="doc examples jemalloc papi +perftools tbb test"

# TODO: some of the forced deps are may be optional
# it would need to work the automagic
RDEPEND="
	tbb? ( dev-cpp/tbb )
	>=dev-libs/boost-1.51
	dev-libs/libxml2
	papi? ( dev-libs/papi )
	sci-libs/hdf5
	>=sys-apps/hwloc-1.8
	>=sys-libs/libunwind-1
	sys-libs/zlib
	perftools? ( >=dev-util/google-perftools-1.7.1 )
"
DEPEND="${RDEPEND}
	app-arch/p7zip
	virtual/pkgconfig
	test? ( dev-lang/python )
"
REQUIRED_USE="test? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}"/hpx-0.9.8-install-path.patch
	"${FILESDIR}"/hpx-0.9.8-multilib.patch
	"${FILESDIR}"/hpx-0.9.8-cmake_dir.patch
)

pkg_setup() {
	use test && python-single-r1_pkg_setup
}

src_configure() {
	CMAKE_BUILD_TYPE=Release
	local mycmakeargs=(
		-DHPX_BUILD_EXAMPLES=OFF
		-DLIB=$(get_libdir)
		-Dcmake_dir=cmake
		$(cmake-utils_use doc HPX_BUILD_DOCUMENTATION)
		$(cmake-utils_use jemalloc HPX_JEMALLOC)
		$(cmake-utils_use test BUILD_TESTING)
		$(cmake-utils_use perftools HPX_GOOGLE_PERFTOOLS)
		$(cmake-utils_use papi HPX_PAPI)
	)
	if use perftools; then
		mycmakeargs+=( -DHPX_MALLOC=tcmalloc )
	elif use jemalloc; then
		mycmakeargs+=( -DHPX_MALLOC=jemalloc )
	elif use tbb; then
		mycmakeargs+=( -DHPX_MALLOC=tbbmalloc )
	else
		mycmakeargs+=( -DHPX_MALLOC=system )
	fi
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
