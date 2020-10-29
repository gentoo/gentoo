# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic fortran-2 toolchain-funcs

DESCRIPTION="Optimized BLAS library based on GotoBLAS2"
HOMEPAGE="http://xianyi.github.com/OpenBLAS/"
SRC_URI="https://github.com/xianyi/OpenBLAS/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="dynamic eselect-ldso index-64bit openmp pthread test"
REQUIRED_USE="?? ( openmp pthread )"
RESTRICT="!test? ( test )"

RDEPEND="
	eselect-ldso? ( >=app-eselect/eselect-blas-0.2
			!app-eselect/eselect-cblas
			>=app-eselect/eselect-lapack-0.2 )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/shared-blas-lapack.patch"
	"${FILESDIR}/${PN}-0.3.10-dont-clobber-fflags.patch"
)

pkg_setup() {
	fortran-2_pkg_setup
	use openmp && tc-check-openmp

	# We need to filter these while building the library, and not just
	# while building the test suite. Will hopefully get fixed upstream:
	# https://github.com/xianyi/OpenBLAS/issues/2657
	use test && filter-flags "-fbounds-check" "-fcheck=bounds" "-fcheck=all"

	export CC=$(tc-getCC) FC=$(tc-getFC)

	use dynamic && \
		export DYNAMIC_ARCH=1 TARGET=GENERIC NUM_THREADS=64 NO_AFFINITY=1

	# disable submake with -j
	export MAKE_NB_JOBS=-1

	# Set these to "nothing" to prevent the default optimization flags
	# from being added in Makefile.system.
	export COMMON_OPT=" " FCOMMON_OPT=" "

	USE_THREAD=0
	if use openmp; then
		USE_THREAD=1; USE_OPENMP=1;
	elif use pthread; then
		USE_THREAD=1; USE_OPENMP=0;
	fi
	export USE_THREAD USE_OPENMP

	export PREFIX="${EPREFIX}/usr"
}

src_unpack() {
	default

	mv "${WORKDIR}"/*OpenBLAS* "${S}" || die

	if use index-64bit; then
		cp -aL "${S}" "${S}-index-64bit" || die
	fi
}

src_compile() {
	# We have to try extra hard to override AR for now.
	# https://github.com/xianyi/OpenBLAS/issues/2654
	emake AR="$(tc-getAR)"
	emake AR="$(tc-getAR)" -Cinterface shared-blas-lapack
	if use index-64bit; then
		emake -C"${S}-index-64bit" INTERFACE64=1 LIBPREFIX=libopenblas64
	fi
}

src_test() {
	emake tests
}

src_install() {
	emake install DESTDIR="${D}" OPENBLAS_INCLUDE_DIR='$(PREFIX)'/include/${PN} \
		OPENBLAS_LIBRARY_DIR='$(PREFIX)'/$(get_libdir)
	dodoc GotoBLAS_*.txt *.md Changelog.txt

	if use eselect-ldso; then
		insinto /usr/$(get_libdir)/blas/openblas/
		doins interface/libblas.so.3
		dosym libblas.so.3 usr/$(get_libdir)/blas/openblas/libblas.so
		doins interface/libcblas.so.3
		dosym libcblas.so.3 usr/$(get_libdir)/blas/openblas/libcblas.so

		insinto /usr/$(get_libdir)/lapack/openblas/
		doins interface/liblapack.so.3
		dosym liblapack.so.3 usr/$(get_libdir)/lapack/openblas/liblapack.so
	fi

	if use index-64bit; then
		insinto /usr/$(get_libdir)/
		dolib.so "${S}-index-64bit"/libopenblas64*.so*
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
