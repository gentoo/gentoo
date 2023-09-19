# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic fortran-2 toolchain-funcs

DESCRIPTION="Optimized BLAS library based on GotoBLAS2"
HOMEPAGE="https://github.com/xianyi/OpenBLAS"
SRC_URI="https://github.com/xianyi/OpenBLAS/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/OpenBLAS-${PV}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="dynamic eselect-ldso index-64bit openmp pthread relapack test"
REQUIRED_USE="?? ( openmp pthread )"
RESTRICT="!test? ( test )"

RDEPEND="
	eselect-ldso? (
		>=app-eselect/eselect-blas-0.2
		>=app-eselect/eselect-lapack-0.2
	)
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${PN}-0.3.23-shared-blas-lapack.patch"
	"${FILESDIR}/${PN}-0.3.21-fix-loong.patch"
	"${FILESDIR}/${PN}-0.3.23-parallel-make.patch"
)

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	elog "This software has a massive number of options that"
	elog "are configurable and it is *impossible* for all of"
	elog "those to fit inside any manageable ebuild."
	elog "The Gentoo provided package has enough to build"
	elog "a fully optimized library for your targeted CPU."
	elog "You can set the CPU target using the environment"
	elog "variable - OPENBLAS_TARGET or it will be detected"
	elog "automatically from the target toolchain (supports"
	elog "cross compilation toolchains)."
	elog "You can control the maximum number of threads"
	elog "using OPENBLAS_NTHREAD, default=64 and number of "
	elog "parallel calls to allow before further calls wait"
	elog "using OPENBLAS_NPARALLEL, default=8."
}

pkg_setup() {
	fortran-2_pkg_setup

	# List of most configurable options - Makefile.rule

	# not an easy fix, https://github.com/xianyi/OpenBLAS/issues/4128
	filter-lto

	# https://github.com/xianyi/OpenBLAS/pull/2663
	tc-export CC FC LD AR AS RANLIB

	# HOSTCC is used for scripting
	export HOSTCC="$(tc-getBUILD_CC)"

	# threading options
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
	USE_THREAD=0
	if use openmp; then
		USE_THREAD=1; USE_OPENMP=1;
	elif use pthread; then
		USE_THREAD=1; USE_OPENMP=0;
	fi
	export USE_THREAD USE_OPENMP

	# disable submake with -j and default optimization flags
	# in Makefile.system
	# Makefile.rule says to not modify COMMON_OPT/FCOMMON_OPT...
	export MAKE_NB_JOBS=-1 \
		   COMMON_OPT=" " \
		   FCOMMON_OPT=" "

	# Target CPU ARCH options
	# generally detected automatically from cross toolchain
	use dynamic && \
		export DYNAMIC_ARCH=1 \
			   NO_AFFINITY=1 \
			   TARGET=GENERIC

	export NUM_PARALLEL=${OPENBLAS_NPARALLEL:-8} \
		   NUM_THREADS=${OPENBLAS_NTHREAD:-64}

	# setting OPENBLAS_TARGET to override auto detection
	# in case the toolchain is not enough to detect
	# https://github.com/xianyi/OpenBLAS/blob/develop/TargetList.txt
	if ! use dynamic && [[ ! -z "${OPENBLAS_TARGET}" ]] ; then
		export TARGET="${OPENBLAS_TARGET}"
	fi

	export NO_STATIC=1

	BUILD_RELAPACK=1
	if ! use relapack; then
		BUILD_RELAPACK=0
	fi

	export PREFIX="${EPREFIX}/usr" BUILD_RELAPACK
}

src_prepare() {
	default

	# Don't build the tests as part of "make all". We'll do
	# it explicitly later if the test phase is enabled.
	sed -e "/^all ::/s/tests //" -i Makefile || die

	# if 64bit-index is needed, create second library
	# with LIBPREFIX=libopenblas64
	if use index-64bit; then
		cp -aL "${S}" "${S}-index-64bit" || die
	fi
}

src_compile() {
	emake shared
	use eselect-ldso && emake -C interface shared-blas-lapack

	if use index-64bit; then
		emake -C"${S}-index-64bit" \
			  INTERFACE64=1 \
			  LIBPREFIX=libopenblas64
	fi
}

src_test() {
	emake tests
}

src_install() {
	emake install DESTDIR="${D}" \
				  OPENBLAS_INCLUDE_DIR='$(PREFIX)'/include/${PN} \
				  OPENBLAS_LIBRARY_DIR='$(PREFIX)'/$(get_libdir)

	dodoc GotoBLAS_*.txt *.md Changelog.txt

	if use index-64bit; then
		dolib.so "${S}-index-64bit"/libopenblas64*.so*
	fi

	if use eselect-ldso; then
		insinto /usr/$(get_libdir)/blas/openblas/
		doins interface/libblas.so.3
		dosym libblas.so.3 usr/$(get_libdir)/blas/openblas/libblas.so
		doins interface/libcblas.so.3
		dosym libcblas.so.3 usr/$(get_libdir)/blas/openblas/libcblas.so

		insinto /usr/$(get_libdir)/lapack/openblas/
		doins interface/liblapack.so.3
		dosym liblapack.so.3 usr/$(get_libdir)/lapack/openblas/liblapack.so
		doins interface/liblapacke.so.3
		dosym liblapacke.so.3 usr/$(get_libdir)/lapack/openblas/liblapacke.so
	fi
}

pkg_postinst() {
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

pkg_postrm() {
	if use eselect-ldso; then
		eselect blas validate
		eselect lapack validate
	fi
}
