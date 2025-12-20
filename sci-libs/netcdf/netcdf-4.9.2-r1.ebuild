# Copyright 1999-2025 Gentoo Authors
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
KEYWORDS="amd64 ~arm arm64 ~ppc ppc64 ~riscv ~x86"
IUSE="blosc bzip2 +dap doc examples hdf +hdf5 mpi szip test zstd"
RESTRICT="!test? ( test )"

# NOTE OPTION(ENABLE_HDF4 "Build netCDF-4 with HDF4 read capability(HDF4, HDF5 and Zlib required)." OFF)
RDEPEND="
	dev-libs/libxml2:=
	virtual/zlib:=
	blosc? ( dev-libs/c-blosc:= )
	bzip2? ( app-arch/bzip2:= )
	dap? ( net-misc/curl:= )
	hdf? (
		media-libs/libjpeg-turbo:=
		sci-libs/hdf:=
		sci-libs/hdf5:=
	)
	hdf5? ( sci-libs/hdf5:=[hl(+),mpi=,szip=,zlib] )
	zstd? ( app-arch/zstd:= )
"

# deflate blosc zstd bz2
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-text/doxygen[dot] )
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
		-DCMAKE_POLICY_DEFAULT_CMP0153="OLD" # exec_program

		-DENABLE_DAP_REMOTE_TESTS=OFF
		#-DENABLE_HDF4_FILE_TESTS=OFF
		-DENABLE_LIBXML2=ON

		-DBUILD_SHARED_LIBS="yes"
		-DBUILD_TESTING="$(usex test)"
		-DBUILD_UTILITIES="yes"

		-DENABLE_DAP="$(usex dap)"
		-DENABLE_DAP2="$(usex dap)"
		-DENABLE_DAP4="$(usex dap)"

		-DENABLE_DOXYGEN="$(usex doc)"
		-DENABLE_EXAMPLES="$(usex examples)"
		-DENABLE_HDF4="$(usex hdf)"
		-DENABLE_NETCDF_4="$(usex hdf5)"
		-DENABLE_TESTS="$(usex test)"

		-DENABLE_NCZARR="yes"
		# NOTE set these via MYCMAKEARGS if need be
		# -DENABLE_NCZARR_FILTERS="yes"
		# -DENABLE_NCZARR_FILTER_TESTING="yes"
		# -DENABLE_NCZARR_ZIP="yes"

		-DCMAKE_DISABLE_FIND_PACKAGE_Blosc="$(usex !blosc)"
		-DCMAKE_DISABLE_FIND_PACKAGE_Bz2="$(usex !bzip2)"
		-DCMAKE_DISABLE_FIND_PACKAGE_Szip="$(usex !szip)"
		-DCMAKE_DISABLE_FIND_PACKAGE_Zstd="$(usex !zstd)"
	)

	cmake_src_configure
}

src_test() {
	if [[ -f "${BUILD_DIR}/nc_test4/run_par_test.sh" ]]; then
		sed -e 's/mpiexec/mpiexec --use-hwthread-cpus/g' -i "${BUILD_DIR}/nc_test4/run_par_test.sh" || die
	fi

	cmake_src_test
}

src_install() {
	cmake_src_install

	# bug #827188
	sed -i -re "s:${EPREFIX}/usr/$(get_libdir)/lib(dl|m).(so|a);:\1;:g" "${ED}/usr/$(get_libdir)/cmake/netCDF/netCDFTargets.cmake" || die
}
