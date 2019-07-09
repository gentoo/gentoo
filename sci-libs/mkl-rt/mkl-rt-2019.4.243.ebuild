# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit eutils

DESCRIPTION="Intel Math Kernel Library (Runtime)"
HOMEPAGE="https://software.intel.com/en-us/mkl"
SRC_URI="https://repo.continuum.io/pkgs/main/linux-64/mkl-2019.4-243.tar.bz2 -> ${P}.tar.bz2"

LICENSE="ISSL" # https://software.intel.com/en-us/mkl/license-faq
SLOT="0"
KEYWORDS="~amd64"
IUSE="eselect-ldso"

# MKL uses Intel/LLVM OpenMP by default.
# One can change the threadding layer to "gnu" or "tbb" through the MKL_THREADING_LAYER env var.
RDEPEND="
eselect-ldso? ( !app-eselect/eselect-cblas
	>=app-eselect/eselect-blas-0.2 )
sys-libs/libomp"

DEPEND=""

S=${WORKDIR}

src_install () {
	insinto  /usr/$(get_libdir)/
	doins lib/*.so

	if use eselect-ldso; then
		dodir /usr/$(get_libdir)/blas/mkl-rt
		dosym ../../libmkl_rt.so usr/$(get_libdir)/blas/mkl-rt/libblas.so
		dosym ../../libmkl_rt.so usr/$(get_libdir)/blas/mkl-rt/libblas.so.3
		dosym ../../libmkl_rt.so usr/$(get_libdir)/blas/mkl-rt/libcblas.so
		dosym ../../libmkl_rt.so usr/$(get_libdir)/blas/mkl-rt/libcblas.so.3
		dosym ../../libomp.so    usr/$(get_libdir)/blas/mkl-rt/libiomp5.so
		dodir /usr/$(get_libdir)/lapack/mkl-rt
		dosym ../../libmkl_rt.so usr/$(get_libdir)/lapack/mkl-rt/liblapack.so
		dosym ../../libmkl_rt.so usr/$(get_libdir)/lapack/mkl-rt/liblapack.so.3
		dosym ../../libmkl_rt.so usr/$(get_libdir)/lapack/mkl-rt/liblapacke.so
		dosym ../../libmkl_rt.so usr/$(get_libdir)/lapack/mkl-rt/liblapacke.so.3
		dosym ../../libomp.so    usr/$(get_libdir)/lapack/mkl-rt/libiomp5.so
	fi
}

pkg_postinst () {
	use eselect-ldso || return
	local libdir=$(get_libdir) me="mkl-rt"

	# check blas
	eselect blas add ${libdir} "${EROOT}"/usr/${libdir}/blas/${me} ${me}
	local current_blas=$(eselect blas show ${libdir} | cut -d' ' -f2)
	if [[ ${current_blas} == "${me}" || -z ${current_blas} ]]; then
		eselect blas set ${libdir} ${me}
		elog "Current eselect: BLAS/CBLAS ($libdir) -> [${current_blas}]."
	else
		elog "Current eselect: BLAS/CBLAS ($libdir) -> [${current_blas}]."
		elog "To use blas [${me}] implementation, you have to issue (as root):"
		elog "\t eselect blas set ${libdir} ${me}"
	fi

	# check lapack
	eselect lapack add ${libdir} "${EROOT}"/usr/${libdir}/lapack/${me} ${me}
	local current_lapack=$(eselect lapack show ${libdir} | cut -d' ' -f2)
	if [[ ${current_lapack} == "${me}" || -z ${current_lapack} ]]; then
		eselect lapack set ${libdir} ${me}
		elog "Current eselect: LAPACK ($libdir) -> [${current_blas}]."
	else
		elog "Current eselect: LAPACK ($libdir) -> [${current_blas}]."
		elog "To use lapack [${me}] implementation, you have to issue (as root):"
		elog "\t eselect lapack set ${libdir} ${me}"
	fi
}

pkg_postrm () {
	if use eselect-ldso; then
		eselect blas validate
		eselect lapack validate
	fi
}
