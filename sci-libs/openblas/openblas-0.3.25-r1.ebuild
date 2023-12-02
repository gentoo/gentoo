# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic fortran-2 toolchain-funcs

MY_P=OpenBLAS-${PV}
DESCRIPTION="Optimized BLAS library based on GotoBLAS2"
HOMEPAGE="https://github.com/xianyi/OpenBLAS"
SRC_URI="https://github.com/OpenMathLib/OpenBLAS/releases/download/v${PV}/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

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
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp

	fortran-2_pkg_setup
}

src_prepare() {
	default

	# TODO: Unbundle lapack like Fedora does?
	# https://src.fedoraproject.org/rpms/openblas/blob/rawhide/f/openblas-0.2.15-system_lapack.patch

	# Don't build the tests as part of "make all". We'll do
	# it explicitly later if the test phase is enabled.
	sed -i -e "/^all :: tests/s: tests::g" Makefile || die

	# If 64bit-index is needed, create second library with LIBPREFIX=libopenblas64
	if use index-64bit; then
		cp -aL "${S}" "${S}-index-64bit" || die
	fi
}

src_configure() {
	# List of most configurable options is in Makefile.rule.

	# Not an easy fix, https://github.com/xianyi/OpenBLAS/issues/4128
	filter-lto

	tc-export CC FC LD AR AS RANLIB

	# HOSTCC is used for scripting
	export HOSTCC="$(tc-getBUILD_CC)"

	# Threading options
	export USE_THREAD=0
	export USE_OPENMP=0
	if use openmp; then
		USE_THREAD=1
		USE_OPENMP=1
	elif use pthread; then
		USE_THREAD=1
		USE_OPENMP=0
	fi

	# Disable submake with -j and default optimization flags in Makefile.system
	# Makefile.rule says to not modify COMMON_OPT/FCOMMON_OPT...
	export MAKE_NB_JOBS=-1 COMMON_OPT=" " FCOMMON_OPT=" "

	# Target CPU ARCH options generally detected automatically from cross toolchain
	#
	# TODO: Rename USE=dynamic -> USE=cpudetection like dev-libs/gmp, media-video/ffmpeg?
	# (may want to then restrict bindist w/ USE=-cpudetection.)
	if use dynamic ; then
		export DYNAMIC_ARCH=1 NO_AFFINITY=1 TARGET=GENERIC
	fi

	export NUM_PARALLEL=${OPENBLAS_NPARALLEL:-8} NUM_THREADS=${OPENBLAS_NTHREAD:-64}

	# Allow setting OPENBLAS_TARGET to override auto detection in case the
	# toolchain is not enough to detect.
	# https://github.com/xianyi/OpenBLAS/blob/develop/TargetList.txt
	if ! use dynamic && [[ ! -z "${OPENBLAS_TARGET}" ]] ; then
		export TARGET="${OPENBLAS_TARGET}"
	fi

	export NO_STATIC=1
	export BUILD_RELAPACK=$(usex relapack 1 0)
	export PREFIX="${EPREFIX}/usr"
}

src_compile() {
	emake shared

	use eselect-ldso && emake -C interface shared-blas-lapack

	if use index-64bit; then
		emake -C "${S}-index-64bit" \
			  INTERFACE64=1 \
			  LIBPREFIX=libopenblas64 shared
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
		dosym -r /usr/$(get_libdir)/libblas.so.3 /usr/$(get_libdir)/blas/openblas/libblas.so
		doins interface/libcblas.so.3
		dosym -r /usr/$(get_libdir)/libcblas.so.3 /usr/$(get_libdir)/blas/openblas/libcblas.so

		insinto /usr/$(get_libdir)/lapack/openblas/
		doins interface/liblapack.so.3
		dosym -r /usr/$(get_libdir)/liblapack.so.3 /usr/$(get_libdir)/lapack/openblas/liblapack.so
		doins interface/liblapacke.so.3
		dosym -r /usr/$(get_libdir)/liblapacke.so.3 /usr/$(get_libdir)/lapack/openblas/liblapacke.so
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
