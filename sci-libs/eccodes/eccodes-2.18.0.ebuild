# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )

inherit cmake fortran-2 python-any-r1

MY_P="${P}-Source"

DESCRIPTION="A set of encoding/decoding APIs and tools for WMO GRIB, BUFR, and GTS messages"
HOMEPAGE="https://confluence.ecmwf.int/display/ECC"
SRC_URI="https://confluence.ecmwf.int/download/attachments/45757960/${MY_P}.tar.gz
	extra-test? ( http://download.ecmwf.org/test-data/eccodes/${PN}_test_data.tar.gz
	http://download.ecmwf.org/test-data/eccodes/data/mercator.grib2 )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

IUSE="+defs examples extra-test fortran memfs netcdf jpeg2k openmp png python szip test threads"

REQUIRED_USE="
	fortran? ( !threads ( openmp ) )
	openmp? ( !threads ( fortran ) )
	threads? ( !fortran !openmp )
	test? ( defs !memfs )
	extra-test? ( test )
	!test? ( memfs? ( python ) )"

RDEPEND="
	sys-libs/zlib
	szip? ( sci-libs/szip )
	netcdf? ( >=sci-libs/netcdf-4.2[hdf5] )
	jpeg2k? ( >=media-libs/openjpeg-2:2 )
	png? ( media-libs/libpng )"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}"

BDEPEND="virtual/pkgconfig"

RESTRICT="!test? ( test )"

S="${WORKDIR}/${MY_P}"

CMAKE_BUILD_TYPE=RelWithDebInfo

pkg_setup() {
	use fortran && fortran-2_pkg_setup
	use python && python-any-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DINSTALL_LIB_DIR="$(get_libdir)"
		-DCMAKE_SKIP_INSTALL_RPATH=TRUE
		-DENABLE_ECCODES_THREADS=$(usex threads TRUE FALSE)
		-DENABLE_ECCODES_OMP_THREADS=$(usex openmp TRUE FALSE)
		-DENABLE_EXAMPLES=OFF  # no need to build examples
		-DENABLE_INSTALL_ECCODES_DEFINITIONS=$(usex defs TRUE FALSE)
		-DENABLE_FORTRAN=$(usex fortran TRUE FALSE)
		-DENABLE_PYTHON=OFF  # py2 support is deprecated
		-DENABLE_NETCDF=$(usex netcdf TRUE FALSE)
		-DENABLE_JPG=$(usex jpeg2k TRUE FALSE)
		-DENABLE_JPG_LIBOPENJPEG=$(usex jpeg2k TRUE FALSE)
		-DENABLE_PNG=$(usex png TRUE FALSE)
		-DENABLE_MEMFS=$(usex memfs TRUE FALSE)
		-DENABLE_EXTRA_TESTS=$(usex extra-test TRUE FALSE)
		-DBUILD_SHARED_LIBS=ON
	)
	use fortran && mycmakeargs+=( -DCMAKE_Fortran_FLAGS="-fallow-argument-mismatch" )
	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use examples; then
		insinto "/usr/share/${PN}/examples"
		doins -r examples/C
		use fortran && doins -r examples/F90
		use python && doins -r examples/python
	fi
}

src_test() {
	if use extra-test; then
		touch "${WORKDIR}"/data/.downloaded
		cp -r "${WORKDIR}"/data/* "${BUILD_DIR}"/data/
		cp "${DISTDIR}"/mercator.grib2 "${BUILD_DIR}"/data/
	fi

	cmake_src_test
}
