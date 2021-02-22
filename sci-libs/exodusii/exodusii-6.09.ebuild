# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FORTRAN_NEEDED="test"
inherit cmake-utils fortran-2

MY_PN="${PN%ii}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Model developed to store and retrieve transient data for finite element analyses"
HOMEPAGE="https://github.com/certik/exodus"
SRC_URI="https://dev.gentoo.org/~asturm/distfiles/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="sci-libs/netcdf[hdf5]"
DEPEND="${RDEPEND}
	test? ( app-shells/tcsh )
"

S="${WORKDIR}"/${MY_P}/${MY_PN}

PATCHES=( "${FILESDIR}"/${P}-multilib.patch )

src_prepare() {
	cmake-utils_src_prepare

	if ! use test; then
		sed -e 's:Fortran::g' -i CMakeLists.txt || die
	fi
}

src_configure() {
	local libdir="$(get_libdir)"

	local mycmakeargs=(
		-DLIB_SUFFIX=${libdir#lib}
		-DPYTHON_INSTALL="${EPREFIX}/usr/share/${PN}"
		-DBUILD_SHARED=$(usex !static-libs)
		-DBUILD_TESTING=$(usex test)
	)
	export NETCDF_DIR="${EPREFIX}/usr/"
	cmake-utils_src_configure
}

src_test() {
	cd "${BUILD_DIR}"/cbind/test || die
	ctest || die
	cd "${BUILD_DIR}"/forbind/test || die
	emake f_check
}
