# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Optimized BLAS library based on GotoBLAS2"
HOMEPAGE="http://xianyi.github.com/OpenBLAS/"
SRC_URI="https://github.com/xianyi/OpenBLAS/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="dynamic openmp pthread serial static-libs eselect-ldso"
REQUIRED_USE="?? ( openmp pthread serial )"

RDEPEND="
eselect-ldso? ( >=app-eselect/eselect-blas-0.2
				!app-eselect/eselect-cblas
				>=app-eselect/eselect-lapack-0.2 )
"
DEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/shared-blas-lapack.patch" )

openblas_flags() {
	local flags=()
	use dynamic && \
		flags+=( DYNAMIC_ARCH=1 TARGET=GENERIC NUM_THREADS=64 NO_AFFINITY=1 )
	if use openmp; then
		flags+=( USE_THREAD=1 USE_OPENMP=1 )
	elif use pthread; then
		flags+=( USE_THREAD=1 USE_OPENMP=0 )
	else
		flags+=( USE_THREAD=0 ) # serial
	fi
	flags+=( DESTDIR="${D}" PREFIX="${EPREFIX}/usr" )
	flags+=( OPENBLAS_INCLUDE_DIR='$(PREFIX)'/include/${PN} )
	flags+=( OPENBLAS_LIBRARY_DIR='$(PREFIX)'/$(get_libdir) )
	echo "${flags[@]}"
}

src_unpack () {
	default
	find "${WORKDIR}" -maxdepth 1 -type d -name \*OpenBLAS\* && \
		mv "${WORKDIR}"/*OpenBLAS* "${S}" || die
}

src_compile () {
	emake $(openblas_flags)
	emake -Cinterface shared-blas-lapack $(openblas_flags)
}

src_install () {
	emake install $(openblas_flags)

	if use eselect-ldso; then
		dodir /usr/$(get_libdir)/blas/openblas/
		insinto /usr/$(get_libdir)/blas/openblas/
		doins interface/libblas.so.3
		dosym libblas.so.3 usr/$(get_libdir)/blas/openblas/libblas.so
		doins interface/libcblas.so.3
		dosym libcblas.so.3 usr/$(get_libdir)/blas/openblas/libcblas.so

		dodir /usr/$(get_libdir)/lapack/openblas/
		insinto /usr/$(get_libdir)/lapack/openblas/
		doins interface/liblapack.so.3
		dosym liblapack.so.3 usr/$(get_libdir)/lapack/openblas/liblapack.so
	fi
}

pkg_postinst () {
	use eselect-ldso || return
	local libdir=$(get_libdir) me="openblas"

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
		elog "Current eselect: LAPACK ($libdir) -> [${current_lapack}]."
	else
		elog "Current eselect: LAPACK ($libdir) -> [${current_lapack}]."
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
