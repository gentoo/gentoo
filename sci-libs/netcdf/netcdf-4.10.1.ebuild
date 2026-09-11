# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

# see hdf4_test/run_get_hdf4_files.sh
TEST_DATA=(
	AMSR_E_L2_Rain_V10_200905312326_A.hdf.gz
	AMSR_E_L3_DailyLand_V06_20020619.hdf.gz
	MYD29.A2009152.0000.005.2009153124331.hdf.gz
	MYD29.A2002185.0000.005.2007160150627.hdf.gz
	MOD29.A2000055.0005.005.2006267200024.hdf.gz
)

DESCRIPTION="Scientific library and interface for array oriented data access"
HOMEPAGE="https://www.unidata.ucar.edu/software/netcdf/"
SRC_URI="
	https://downloads.unidata.ucar.edu/netcdf-c/${PV}/${PN}-c-${PV}.tar.gz
	hdf? ( test? (
		${TEST_DATA[@]/#/https://resources.unidata.ucar.edu/netcdf/sample_data/hdf4/}
	) )
"
S="${WORKDIR}"/${PN}-c-${PV}

LICENSE="UCAR-Unidata"
# SONAME of libnetcdf.so
SLOT="0/22"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="blosc bzip2 +dap doc examples hdf +hdf5 mpi szip test zstd"
RESTRICT="!test? ( test )"

# NOTE OPTION(ENABLE_HDF4 "Build netCDF-4 with HDF4 read capability(HDF4, HDF5 and Zlib required)." OFF)
#
# extra deps for hdf5 for https://github.com/Unidata/netcdf-c/issues/3198,
# still automagic in 4.10.1 :(
RDEPEND="
	dev-libs/libxml2:=
	dev-libs/libzip:=
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
	szip? ( virtual/szip:= )
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
		-DNETCDF_ENABLE_DAP_REMOTE_TESTS=OFF
		#-DNETCDF_ENABLE_HDF4_FILE_TESTS=OFF
		-DNETCDF_ENABLE_LIBXML2=ON

		-DBUILD_SHARED_LIBS="yes"
		-DBUILD_TESTING="$(usex test)"
		-DNETCDF_BUILD_UTILITIES="yes"

		-DNETCDF_ENABLE_DAP="$(usex dap)"
		-DNETCDF_ENABLE_DAP2="$(usex dap)"
		-DNETCDF_ENABLE_DAP4="$(usex dap)"

		-DNETCDF_ENABLE_DOXYGEN="$(usex doc)"
		-DNETCDF_ENABLE_EXAMPLES="$(usex examples)"
		-DNETCDF_ENABLE_HDF4="$(usex hdf)"
		-DNETCDF_ENABLE_HDF5="$(usex hdf5)"
		-DNETCDF_ENABLE_TESTS="$(usex test)"

		-DNETCDF_ENABLE_NCZARR="yes"
		# NOTE set these via MYCMAKEARGS if need be
		# -DNETCDF_ENABLE_NCZARR_FILTERS="yes"
		# -DNETCDF_ENABLE_NCZARR_FILTER_TESTING="yes"
		# -DNETCDF_ENABLE_NCZARR_ZIP="yes"

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
	# hdf4_test/ only exists with USE=hdf, see CMakeLists.txt:1530
	if use hdf; then
		mv "${WORKDIR}"/*.hdf "${BUILD_DIR}/hdf4_test/" || die
	fi

	cmake_src_test
}
