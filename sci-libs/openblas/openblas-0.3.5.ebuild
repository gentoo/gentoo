# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fortran-2 toolchain-funcs

DESCRIPTION="OpenBLAS is an optimized BLAS library based on GotoBLAS2 1.13 BSD version"
HOMEPAGE="http://xianyi.github.com/OpenBLAS/"
SRC_URI="https://github.com/xianyi/OpenBLAS/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+cblas dynamic int64 +lapack np2 np4 np8 np16 openmp static-libs +threads"
REQUIRED_USE="?? ( np2 np4 np8 np16 )"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	# https://github.com/xianyi/OpenBLAS/issues/2048
	"${FILESDIR}/${P}-generic.patch"
)

src_unpack() {
	default
	mv "${WORKDIR}"/*OpenBLAS* "${S}" || die
}

src_prepare() {
	default
	# Set compiler and common CFLAGS.
	sed \
		-e "s:^#\s*\(CC\)\s*=.*:\1=$(tc-getCC):" \
		-e "s:^#\s*\(FC\)\s*=.*:\1=$(tc-getFC):" \
		-e "s:^#\s*\(COMMON_OPT\)\s*=.*:\1=${CFLAGS}:" \
		-i "$S"/Makefile.rule || die
	# Make quiet, disable false-positives warnings.
	sed \
		-e 's/-Wall//g' \
		-i "$S"/Makefile.system || die
}

src_configure() {
	default
	# Set instances run in parallel for OpenMP.
	local num_parallel=()
	use np2 && num_parallel+=( NUM_PARALLEL=2 )
	use np4 && num_parallel+=( NUM_PARALLEL=4 )
	use np8 && num_parallel+=( NUM_PARALLEL=8 )
	use np16 && num_parallel+=( NUM_PARALLEL=16 )
	# Set openblas flags.
	openblas_flags=()
	use dynamic && openblas_flags+=( DYNAMIC_ARCH=1 DYNAMIC_OLDER=1 TARGET=GENERIC NUM_THREADS=64 NO_AFFINITY=1 )
	use int64 && openblas_flags+=( INTERFACE64=1 )
	use !cblas && openblas_flags+=( NO_CBLAS=1 )
	use !lapack && openblas_flags+=( NO_LAPACK=1 )
	# Test for OpenMP support with the current compiler.
	use openmp && tc-check-openmp
	use static-libs && openblas_flags+=( NO_SHARED=1 )
	if use threads; then
	openblas_flags+=( USE_THREAD=1 USE_OPENMP=0 )
	elif use openmp; then
	openblas_flags+=( USE_OPENMP=1 $(echo "${num_parallel[@]}") )
	else
	openblas_flags+=( USE_THREAD=0 )
	fi
}

src_compile() {
	# Openblas already does multi-jobs.
	MAKEOPTS+=" -j1"
	# Flags already defined, fix twice definition.
	unset CFLAGS && unset FFLAGS || die "couldn't unset flags"
	emake ${openblas_flags[@]}
}

src_test() {
	emake tests ${openblas_flags[@]}
}

src_install() {
	emake install \
		DESTDIR="${D}" PREFIX="${EPREFIX}" ${openblas_flags[@]} \
		OPENBLAS_INCLUDE_DIR='$(PREFIX)'/usr/include/${PN} \
		OPENBLAS_LIBRARY_DIR='$(PREFIX)'/usr/lib64
	dobin "${FILESDIR}"/openblas
	dodoc GotoBLAS_{01Readme,03FAQ,04FAQ,05LargePage,06WeirdPerformance}.txt *md Changelog.txt
}

CYAN=$'\e[1;36m'

pkg_postinst() {
	elog "-----SWITCH BETWEEN [BLAS] [LAPACK] [CBLAS] [OPENBLAS]-------"
	elog "                      openblas --help                        "
	elog "-------------------------------------------------------------"
	elog "${CYAN}usage: openblas [--cblas]"
	elog "${CYAN}--openblas		*-default      -->  *-OpenBLAS"
	elog "${CYAN}--blas		blas-default   -->  OpenBLAS"
	elog "${CYAN}--lapack		lapack-default -->  OpenBLAS"
	elog "${CYAN}--cblas		cblas-default  -->  OpenBLAS"
	elog "${CYAN}--default		*-OpenBLAS     -->  *-default"
	elog "${CYAN}--blas-default	OpenBLAS       -->  blas-default"
	elog "${CYAN}--lapack-default	OpenBLAS       -->  lapack-default"
	elog "${CYAN}--cblas-default	OpenBLAS       -->  cblas-default"
	elog "${CYAN}--status		show status"
	elog "${CYAN}--version		display version"
	elog "${CYAN}--help		display help"
	elog "-------------------------------------------------------------"
	elog "--------------------------CFLAGS-----------------------------"
	elog "If you get compile errors first check /etc/portage/make.conf"
	elog "and be sure you are on safe CFLAGS -->"
	elog "https://wiki.gentoo.org/wiki/Safe_CFLAGS"
	elog "-------------------------------------------------------------"
	elog "--------------------------ULIMIT-----------------------------"
	elog "If build worked fine and passed all tests, but you get"
	elog "segfaults,first try to define ${CYAN}ulimit -s unlimited"
	elog "-------------------------------------------------------------"
	elog "-----------------------NUM PARALLEL--------------------------"
	elog "If you have enabled OPENMP and your application would call"
	elog "OpenBLAS's calculation API from multiple threads, you should"
	elog "set NUM PARALLEL threads. ( ${CYAN}np2 np4 np8 np16 )"
}
