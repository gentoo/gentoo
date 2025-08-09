# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A BLAS and LAPACK wrapper library with runtime exchangable backends"
HOMEPAGE="
	https://www.mpi-magdeburg.mpg.de/projects/flexiblas/
	https://gitlab.mpi-magdeburg.mpg.de/software/flexiblas-release/
"
SRC_URI="https://csc.mpi-magdeburg.mpg.de/mpcsc/software/flexiblas/${P}.tar.xz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	sci-libs/lapack:=
"
RDEPEND="
	${DEPEND}
"

src_prepare() {
	cmake_src_prepare

	# remove bundled netlib blas/lapack
	rm -r contributed || die
}

src_configure() {
	local mycmakeargs=(
		-DTESTS=$(usex test)
		-DCBLAS=ON
		# TODO: ILP64 variant
		-DINTEGER8=OFF
		-DLAPACK=ON
		-DEXAMPLES=OFF
		# disable all automagic
		-DBLAS_AUTO_DETECT=OFF
		# respect CFLAGS
		-DLTO=OFF
		# use system sci-libs/lapack
		-DSYS_BLAS_LIBRARY="${ESYSROOT}/usr/$(get_libdir)/libblas.so"
		-DSYS_LAPACK_LIBRARY="${ESYSROOT}/usr/$(get_libdir)/liblapack.so"
	)
	cmake_src_configure
}
