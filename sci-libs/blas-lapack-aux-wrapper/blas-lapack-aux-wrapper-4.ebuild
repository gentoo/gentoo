# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit meson python-any-r1 toolchain-funcs

LAPACK_VER=3.12.1
DESCRIPTION="BLAS/LAPACK wrappers for FlexiBLAS"
HOMEPAGE="https://gitweb.gentoo.org/proj/blas-lapack-aux-wrapper.git/"
SRC_URI="
	https://dev.gentoo.org/~mgorny/dist/${P}.tar.xz
	test? (
		https://github.com/Reference-LAPACK/lapack/archive/v${LAPACK_VER}.tar.gz
			-> lapack-${LAPACK_VER}.tar.gz
	)
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ppc64 ~riscv ~x86"
IUSE="index64 test"
RESTRICT="!test? ( test )"

RDEPEND="
	!sci-libs/lapack[-flexiblas(-)]
	>=sci-libs/flexiblas-3.4.82-r4:=[index64(-)?]
"
DEPEND="
	${RDEPEND}
	sci-libs/lapack:=[flexiblas(-),index64(-)?,lapacke]
"
BDEPEND="
	${PYTHON_DEPS}
"

# we do not call the compiler, only the linker
QA_FLAGS_IGNORED=".*"

src_configure() {
	# We rely on some specific linker features (bug #965199)
	if ! tc-ld-is-bfd && ! tc-ld-is-lld; then
		tc-ld-force-bfd
	fi

	local emesonargs=(
		-Dilp64=$(usex index64 true false)
	)

	meson_src_configure
}

check_result() {
	local f=${1}

	if ! grep -q "<flexiblas> Check if shared library exist" "${f}.out"; then
		die "No FlexiBLAS output found in ${f}.out"
	fi
	if grep -q -i "FAIL" "${f}.out"; then
		die "Test failed in ${f}.out"
	fi
}

run_test() {
	local f=${1}

	einfo "Running ${f} ..."
	"${f}" &> "${f}.out" || die "Running ${f} failed"
	check_result "${f}"
}

src_test() {
	# a. get indication that FlexiBLAS is actually used on stderr.
	local -x FLEXIBLAS_VERBOSE=1
	# b. force fallback to Netlib LAPACK.
	local -x FLEXIBLAS=libflexiblas_netlib.so

	tc-export CC FC AR RANLIB

	cd "${WORKDIR}/lapack-${LAPACK_VER}" || die
	cat > make.inc <<-EOF || die
		FFLAGS_DRV   = \$(FFLAGS)
		FFLAGS_NOOPT = \$(FFLAGS) -O0
		ARFLAGS      = rv

		BLASLIB      = ${BUILD_DIR}/libblas.so
		CBLASLIB     = ${BUILD_DIR}/libcblas.so
		LAPACKLIB    = ${BUILD_DIR}/liblapack.so
		TMGLIB       = \$(TOPSRCDIR)/libtmglib.a
		LAPACKELIB   = ${BUILD_DIR}/liblapacke.so
	EOF

	emake -C BLAS/TESTING xblat1d
	emake -C CBLAS include/cblas_mangling.h
	run_test BLAS/TESTING/xblat1d

	emake -C CBLAS/testing xdcblat1
	run_test CBLAS/testing/xdcblat1

	emake -C TESTING/MATGEN
	emake -C TESTING dbb.out
	check_result TESTING/dbb
}

src_install() {
	meson_src_install

	local f
	cd "${ED}/usr/$(get_libdir)" || die
	mkdir blas-lapack-aux-wrapper || die
	mv lib* blas-lapack-aux-wrapper/ || die
	for f in blas-lapack-aux-wrapper/*.so; do
		ln -s "${f}" || die
	done
}
