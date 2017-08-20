# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FORTRAN_NEEDED=fortran
FORTRAN_STANDARD="77 90"
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit cmake-utils toolchain-funcs fortran-2 python-single-r1

PID=3473437

DESCRIPTION="Library for encoding and decoding WMO FM-92 GRIB messages"
HOMEPAGE="https://software.ecmwf.int/wiki/display/GRIB/Home"
SRC_URI="https://software.ecmwf.int/wiki/download/attachments/${PID}/${P}-Source.tar.gz
	test? ( http://download.ecmwf.org/test-data/grib_api/grib_api_test_data.tar.gz )"

S="${WORKDIR}/${P}-Source"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="aec doc examples fortran jpeg2k netcdf png python static-libs test threads"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	aec? ( sci-libs/libaec:= )
	jpeg2k? ( media-libs/jasper:= )
	netcdf? ( sci-libs/netcdf:= )
	png? ( media-libs/libpng:= )
	python? (
		${PYTHON_DEPS}
		dev-python/numpy[${PYTHON_USEDEP}]
	)"

DEPEND="${RDEPEND}
	python? ( dev-lang/swig )
	test? ( dev-libs/boost )"

PATCHES=(
	"${FILESDIR}"/${P}-disable-failing-test.patch
	"${FILESDIR}"/${P}-add-missing-destdir.patch
)

pkg_setup() {
	use fortran && fortran-2_pkg_setup
	use python && python-single-r1_pkg_setup
}

src_unpack() {
	# only unpack the source and not the test data at this stage
	unpack ${P}-Source.tar.gz
}

src_prepare() {
	# remove package build type to allow gentoo one
	sed -i -e '/include(ecbuild_define_build_types)/d' cmake/ecbuild_system.cmake || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DDISABLE_OS_CHECK=ON
		-DENABLE_EXAMPLES=OFF
		-DENABLE_ALIGN_MEMORY=ON
		-DENABLE_MEMORY_MANAGEMENT=ON
		-DENABLE_GRIB_TIMER=ON
		-DENABLE_RELATIVE_RPATHS=OFF
		-DENABLE_RPATHS=OFF
		-DENABLE_AEC="$(usex aec)"
		-DENABLE_FORTRAN="$(usex fortran)"
		-DENABLE_GRIB_THREADS="$(usex threads)"
		-DENABLE_JPG="$(usex jpeg2k)"
		-DENABLE_NETCDF="$(usex netcdf)"
		-DENABLE_PNG="$(usex png)"
		-DENABLE_PYTHON="$(usex python)"
		-DENABLE_TESTS="$(usex test)"
	)
	use static-libs && mycmakeargs+=( -DBUILD_SHARED_LIBS=BOTH )
	cmake-utils_src_configure
}

src_test() {
	# unpack here because subdirectory tree
	use test && cd "${BUILD_DIR}" && unpack grib_api_test_data.tar.gz || die
	cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install
	insinto /usr/share/doc/${PF}
	use examples && doins -r examples
	use doc && doins -r html
}
