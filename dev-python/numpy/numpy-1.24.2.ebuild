# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} pypy3 )
PYTHON_REQ_USE="threads(+)"

FORTRAN_NEEDED=lapack

inherit distutils-r1 flag-o-matic fortran-2 pypi toolchain-funcs

DOC_PV=${PV}
DESCRIPTION="Fast array and numerical python library"
HOMEPAGE="
	https://numpy.org/
	https://github.com/numpy/numpy/
	https://pypi.org/project/numpy/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="lapack"

RDEPEND="
	lapack? (
		>=virtual/cblas-3.8
		>=virtual/lapack-3.8
	)
"
BDEPEND="
	${RDEPEND}
	>=dev-python/cython-0.29.30[${PYTHON_USEDEP}]
	lapack? (
		virtual/pkgconfig
	)
	test? (
		$(python_gen_cond_dep '
			>=dev-python/cffi-1.14.0[${PYTHON_USEDEP}]
		' 'python*')
		dev-python/charset_normalizer[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-5.8.0[${PYTHON_USEDEP}]
		>=dev-python/pytz-2019.3[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}"/numpy-1.22.0-no-hardcode-blasv2.patch
)

distutils_enable_tests pytest

python_prepare_all() {
	# Allow use with setuptools 60.x
	# See numpy-1.22.1-revert-setuptools-upper-bound.patch for details
	export SETUPTOOLS_USE_DISTUTILS=stdlib

	if use lapack; then
		local incdir="${EPREFIX}"/usr/include
		local libdir="${EPREFIX}"/usr/$(get_libdir)
		cat >> site.cfg <<-EOF || die
			[blas]
			include_dirs = ${incdir}
			library_dirs = ${libdir}
			blas_libs = cblas,blas
			[lapack]
			library_dirs = ${libdir}
			lapack_libs = lapack
		EOF
	else
		export {ATLAS,PTATLAS,BLAS,LAPACK,MKL}=None
	fi

	export CC="$(tc-getCC) ${CFLAGS}"

	append-flags -fno-strict-aliasing

	# See progress in http://projects.scipy.org/scipy/numpy/ticket/573
	# with the subtle difference that we don't want to break Darwin where
	# -shared is not a valid linker argument
	if [[ ${CHOST} != *-darwin* ]]; then
		append-ldflags -shared
	fi

	# only one fortran to link with:
	# linking with cblas and lapack library will force
	# autodetecting and linking to all available fortran compilers
	append-fflags -fPIC
	if use lapack; then
		NUMPY_FCONFIG="config_fc --noopt --noarch"
		# workaround bug 335908
		[[ $(tc-getFC) == *gfortran* ]] && NUMPY_FCONFIG+=" --fcompiler=gnu95"
	fi

	# don't version f2py, we will handle it.
	sed -i -e '/f2py_exe/s: + os\.path.*$::' numpy/f2py/setup.py || die

	distutils-r1_python_prepare_all
}

python_compile() {
	export MAKEOPTS=-j1 #660754

	distutils-r1_python_compile ${NUMPY_FCONFIG}
}

python_test() {
	local EPYTEST_DESELECT=(
		# very disk- and memory-hungry
		numpy/lib/tests/test_histograms.py::TestHistogram::test_big_arrays
		numpy/lib/tests/test_io.py::test_large_zip

		# precision problems
		numpy/core/tests/test_umath_accuracy.py::TestAccuracy::test_validate_transcendentals

		# runs the whole test suite recursively, that's just crazy
		numpy/core/tests/test_mem_policy.py::test_new_policy

		# very slow, unlikely to be practically useful
		numpy/typing/tests/test_typing.py
	)

	if use arm && [[ $(uname -m || echo "unknown") == "armv8l" ]] ; then
		# Degenerate case. arm32 chroot on arm64.
		# bug #774108
		EPYTEST_DESELECT+=(
			numpy/core/tests/test_cpu_features.py::Test_ARM_Features::test_features
		)
	fi

	if use x86 ; then
		EPYTEST_DESELECT+=(
			# https://github.com/numpy/numpy/issues/18388
			numpy/core/tests/test_umath.py::TestRemainder::test_float_remainder_overflow
			# https://github.com/numpy/numpy/issues/18387
			numpy/random/tests/test_generator_mt19937.py::TestRandomDist::test_pareto
			# more precision problems
			numpy/core/tests/test_einsum.py::TestEinsum::test_einsum_sums_int16
		)
	fi
	if use arm || use x86 ; then
		EPYTEST_DESELECT+=(
			# too large for 32-bit platforms
			numpy/core/tests/test_ufunc.py::TestUfunc::test_identityless_reduction_huge_array
		)
	fi

	distutils_install_for_testing --single-version-externally-managed \
		--record "${TMPDIR}/record.txt" ${NUMPY_FCONFIG}

	cd "${TEST_DIR}/lib" || die
	epytest -k "not _fuzz"
}

python_install() {
	# https://github.com/numpy/numpy/issues/16005
	local mydistutilsargs=( build_src )
	distutils-r1_python_install ${NUMPY_FCONFIG}
	python_optimize
}

python_install_all() {
	local DOCS=( LICENSE.txt README.md THANKS.txt )
	distutils-r1_python_install_all
}
