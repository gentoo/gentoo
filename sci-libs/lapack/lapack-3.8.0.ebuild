# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake-utils

DESCRIPTION="BLAS,CBLAS,LAPACK,LAPACKE reference implementations"
HOMEPAGE="http://www.netlib.org/lapack/"
SRC_URI="http://www.netlib.org/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="lapacke doc eselect-ldso"
# TODO: static-libs 64bit-index

RDEPEND="
	eselect-ldso? ( >=app-eselect/eselect-blas-0.2
	>=app-eselect/eselect-lapack-0.2 )
	!app-eselect/eselect-cblas
	!sci-libs/blas-reference
	!sci-libs/cblas-reference
	!sci-libs/lapack-reference
	!sci-libs/lapacke-reference
	virtual/fortran
	doc? ( app-doc/blas-docs )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DCBLAS=ON
		-DLAPACKE=$(usex lapacke)
		-DBUILD_SHARED_LIBS=ON
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	use eselect-ldso || return
	# Create private lib directory for eselect::blas (ld.so.conf)
	dodir /usr/$(get_libdir)/blas/reference
	dosym ../../libblas.so usr/$(get_libdir)/blas/reference/libblas.so
	dosym ../../libblas.so.3 usr/$(get_libdir)/blas/reference/libblas.so.3
	dosym ../../libcblas.so usr/$(get_libdir)/blas/reference/libcblas.so
	dosym ../../libcblas.so.3 usr/$(get_libdir)/blas/reference/libcblas.so.3

	# Create private lib directory for eselect::lapack (ld.so.conf)
	dodir /usr/$(get_libdir)/lapack/reference
	dosym ../../liblapack.so usr/$(get_libdir)/lapack/reference/liblapack.so
	dosym ../../liblapack.so.3 usr/$(get_libdir)/lapack/reference/liblapack.so.3
}

pkg_postinst() {
	use eselect-ldso || return

	local me=reference libdir=$(get_libdir)
	# check eselect-blas
	eselect blas add ${libdir} "${EROOT}"/usr/${libdir}/blas/${me} ${me}
	local current_blas=$(eselect blas show ${libdir} | cut -d' ' -f2)
	if [[ ${current_blas} == ${me} || -z ${current_blas} ]]; then
		eselect blas set ${libdir} ${me}
		elog "Current eselect: BLAS ($libdir) -> [${current_blas}]."
	else
		elog "Current eselect: BLAS ($libdir) -> [${current_blas}]."
		elog "To use blas [${me}] implementation, you have to issue (as root):"
		elog "\t eselect blas set ${libdir} ${me}"
	fi

	# check eselect-lapack
	eselect lapack add ${libdir} "${EROOT}"/usr/${libdir}/lapack/${me} ${me}
	local current_lapack=$(eselect lapack show ${libdir} | cut -d' ' -f2)
	if [[ ${current_lapack} == ${me} || -z ${current_lapack} ]]; then
		eselect lapack set ${libdir} ${me}
		elog "Current eselect: LAPACK ($libdir) -> [${current_lapack}]."
	else
		elog "Current eselect: LAPACK ($libdir) -> [${current_lapack}]."
		elog "To use lapack [${me}] implementation, you have to issue (as root):"
		elog "\t eselect lapack set ${libdir} ${me}"
	fi
}

pkg_postrm() {
	use eselect-ldso || return

	eselect blas validate
	eselect lapack validate
}
