# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Scientific library and interface for array oriented data access"
HOMEPAGE="https://www.unidata.ucar.edu/software/netcdf/"
SRC_URI="https://downloads.unidata.ucar.edu/netcdf-c/${PV}/${PN}-c-${PV}.tar.gz"
S="${WORKDIR}"/${PN}-c-${PV}

LICENSE="UCAR-Unidata"
# SONAME of libnetcdf.so
SLOT="0/19"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 -riscv ~x86 ~amd64-linux ~x86-linux"
IUSE="+dap doc examples hdf +hdf5 mpi szip test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libxml2
	dap? ( net-misc/curl:= )
	hdf? (
		media-libs/libjpeg-turbo:=
		sci-libs/hdf:=
		sci-libs/hdf5:=
	)
	hdf5? ( sci-libs/hdf5:=[hl(+),mpi=,szip=,zlib] )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )
"

REQUIRED_USE="
	szip? ( hdf5 )
	mpi? ( hdf5 )
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.7.4-big-endian-test.patch
)

src_configure() {
	use mpi && export CC=mpicc

	local mycmakeargs=(
		-DENABLE_DAP_REMOTE_TESTS=OFF
		#-DENABLE_HDF4_FILE_TESTS=OFF
		-DENABLE_LIBXML2=ON
		-DBUILD_UTILITIES=ON
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
	# Still needs -j1 as of 4.9.2, see bug #621486 (fixes in 4.9.1 weren't enough)
	cmake_src_test -j1
}

src_install() {
	cmake_src_install

	# bug #827188
	sed -i -e "s:${EPREFIX}/usr/$(get_libdir)/libdl.so;:dl;:" "${ED}/usr/$(get_libdir)/cmake/netCDF/netCDFTargets.cmake" || die
}
