# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Scientific library and interface for array oriented data access"
HOMEPAGE="https://www.unidata.ucar.edu/software/netcdf/"
SRC_URI="https://github.com/Unidata/netcdf-c/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="UCAR-Unidata"
SLOT="0/18"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="+dap doc examples hdf +hdf5 mpi szip test tools"
RESTRICT="!test? ( test )"

RDEPEND="
	dap? ( net-misc/curl:0= )
	hdf? (
		sci-libs/hdf:0=
		sci-libs/hdf5:0=
		virtual/jpeg
	)
	hdf5? ( sci-libs/hdf5:0=[hl(+),mpi=,szip=,zlib] )"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( app-doc/doxygen[dot] )
	virtual/pkgconfig"

REQUIRED_USE="
	test? ( tools )
	szip? ( hdf5 )
	mpi? ( hdf5 )"

S="${WORKDIR}/${PN}-c-${PV}"

src_prepare() {
	# skip test that requires network
	sed -i -e '/run_get_hdf4_files/d' hdf4_test/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	use mpi && export CC=mpicc

	local mycmakeargs=(
		-DENABLE_DAP_REMOTE_TESTS=OFF
		-DBUILD_UTILITIES=$(usex tools)
		-DENABLE_DAP=$(usex dap)
		-DENABLE_DOXYGEN=$(usex doc)
		-DENABLE_EXAMPLES=$(usex examples)
		-DENABLE_HDF4=$(usex hdf)
		-DENABLE_NETCDF_4=$(usex hdf5)
		-DENABLE_TESTS=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	# fails parallel tests: bug #621486
	cmake_src_test -j1
}
