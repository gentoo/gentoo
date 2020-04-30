# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils fortran-2 toolchain-funcs

DESCRIPTION="Subset of LAPACK routines redesigned for heterogenous (MPI) computing"
HOMEPAGE="https://www.netlib.org/scalapack/"
SRC_URI="https://www.netlib.org/scalapack/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/lapack
	virtual/mpi"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
)

src_prepare() {
	cmake-utils_src_prepare

	if use static-libs; then
		mkdir "${WORKDIR}/${PN}_static" || die
	fi
	# mpi does not have a pc file
	sed -i -e 's/mpi//' scalapack.pc.in || die
}

src_configure() {
	scalapack_configure() {
		local mycmakeargs=(
			-DUSE_OPTIMIZED_LAPACK_BLAS=ON
			-DBLAS_LIBRARIES="$($(tc-getPKG_CONFIG) --libs blas)"
			-DLAPACK_LIBRARIES="$($(tc-getPKG_CONFIG) --libs lapack)"
			-DBUILD_TESTING=$(usex test)
			$@
		)
		cmake-utils_src_configure
	}

	scalapack_configure -DBUILD_SHARED_LIBS=ON -DBUILD_STATIC_LIBS=OFF
	use static-libs && \
		CMAKE_BUILD_DIR="${WORKDIR}/${PN}_static" scalapack_configure \
		-DBUILD_SHARED_LIBS=OFF -DBUILD_STATIC_LIBS=ON
}

src_compile() {
	cmake-utils_src_compile
	use static-libs && \
		CMAKE_BUILD_DIR="${WORKDIR}/${PN}_static" cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	use static-libs && \
		CMAKE_BUILD_DIR="${WORKDIR}/${PN}_static" cmake-utils_src_install

	insinto /usr/include/blacs
	doins BLACS/SRC/*.h

	insinto /usr/include/scalapack
	doins PBLAS/SRC/*.h
}
