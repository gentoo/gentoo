# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYTHON_COMPAT=( python3_{10..13} pypy3 )
PYTHON_REQ_USE="threads(+)"
FORTRAN_NEEDED=lapack

inherit distutils-r1 flag-o-matic fortran-2 pypi

DESCRIPTION="Fast array and numerical python library"
HOMEPAGE="
	https://numpy.org/
	https://github.com/numpy/numpy/
	https://pypi.org/project/numpy/
"

LICENSE="BSD"
SLOT="0/2"
# +lapack because the internal fallbacks are pretty slow. Building without blas
# is barely supported anyway, see bug #914358.
IUSE="big-endian +lapack"

RDEPEND="
	lapack? (
		>=virtual/cblas-3.8
		>=virtual/lapack-3.8
	)
"
BDEPEND="
	${RDEPEND}
	>=dev-build/meson-1.1.0
	>=dev-python/cython-3.0.6[${PYTHON_USEDEP}]
	lapack? (
		virtual/pkgconfig
	)
	test? (
		$(python_gen_cond_dep '
			>=dev-python/cffi-1.14.0[${PYTHON_USEDEP}]
		' 'python*')
		dev-python/charset-normalizer[${PYTHON_USEDEP}]
		>=dev-python/hypothesis-5.8.0[${PYTHON_USEDEP}]
		>=dev-python/pytz-2019.3[${PYTHON_USEDEP}]
	)
"

QA_CONFIG_IMPL_DECL_SKIP=(
	# https://bugs.gentoo.org/925367
	vrndq_f32
)

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_prepare_all() {
	# bug #922457
	filter-lto
	# https://github.com/numpy/numpy/issues/25004
	append-flags -fno-strict-aliasing

	distutils-r1_python_prepare_all
}

python_configure_all() {
	DISTUTILS_ARGS=(
		-Dallow-noblas=$(usex !lapack true false)
		-Dblas=$(usev lapack cblas)
		-Dlapack=$(usev lapack lapack)
		# TODO: cpu-* options
	)
}

python_test() {
	local EPYTEST_DESELECT=(
		# Very disk-and-memory-hungry
		numpy/lib/tests/test_io.py::TestSaveTxt::test_large_zip
		numpy/lib/tests/test_io.py::TestSavezLoad::test_closing_fid
		numpy/lib/tests/test_io.py::TestSavezLoad::test_closing_zipfile_after_load

		# Precision problems
		numpy/_core/tests/test_umath_accuracy.py::TestAccuracy::test_validate_transcendentals

		# Runs the whole test suite recursively, that's just crazy
		numpy/core/tests/test_mem_policy.py::test_new_policy

		numpy/typing/tests/test_typing.py
		# Uses huge amount of memory
		numpy/core/tests/test_mem_overlap.py
	)

	if [[ $(uname -m) == armv8l ]]; then
		# Degenerate case of arm32 chroot on arm64, bug #774108
		EPYTEST_DESELECT+=(
			numpy/_core/tests/test_cpu_features.py::Test_ARM_Features::test_features
		)
	fi

	case ${ARCH} in
		arm)
			EPYTEST_DESELECT+=(
				# TODO: warnings
				numpy/_core/tests/test_umath.py::TestSpecialFloats::test_unary_spurious_fpexception

				# TODO
				numpy/_core/tests/test_function_base.py::TestLinspace::test_denormal_numbers
				numpy/f2py/tests/test_kind.py::TestKind::test_real
				numpy/f2py/tests/test_kind.py::TestKind::test_quad_precisionn

				# require too much memory
				'numpy/_core/tests/test_multiarray.py::TestDot::test_huge_vectordot[complex128]'
				'numpy/_core/tests/test_multiarray.py::TestDot::test_huge_vectordot[float64]'
			)
			;;
		hppa)
			EPYTEST_DESELECT+=(
				# https://bugs.gentoo.org/942689
				"numpy/_core/tests/test_dtype.py::TestBuiltin::test_dtype[int]"
				"numpy/_core/tests/test_dtype.py::TestBuiltin::test_dtype[float]"
				numpy/f2py/tests/test_kind.py::TestKind::test_real
				numpy/f2py/tests/test_kind.py::TestKind::test_quad_precision
				numpy/tests/test_ctypeslib.py::TestAsArray::test_reference_cycles
				numpy/tests/test_ctypeslib.py::TestAsArray::test_segmentation_fault
				numpy/tests/test_ctypeslib.py::TestAsCtypesType::test_scalar
				numpy/tests/test_ctypeslib.py::TestAsCtypesType::test_subarray
				numpy/tests/test_ctypeslib.py::TestAsCtypesType::test_structure
				numpy/tests/test_ctypeslib.py::TestAsCtypesType::test_structure_aligned
				numpy/tests/test_ctypeslib.py::TestAsCtypesType::test_union
				numpy/tests/test_ctypeslib.py::TestAsCtypesType::test_padded_union
			)
			;;
		ppc|x86)
			EPYTEST_DESELECT+=(
				# require too much memory
				'numpy/_core/tests/test_multiarray.py::TestDot::test_huge_vectordot[complex128]'
				'numpy/_core/tests/test_multiarray.py::TestDot::test_huge_vectordot[float64]'
			)
			;;
	esac

	if [[ ${CHOST} == powerpc64le-* ]]; then
		EPYTEST_DESELECT+=(
			# long double thingy
			numpy/_core/tests/test_scalarprint.py::TestRealScalars::test_ppc64_ibm_double_double128
		)
	fi

	if use big-endian; then
		EPYTEST_DESELECT+=(
			# ppc64 and sparc
			numpy/linalg/tests/test_linalg.py::TestDet::test_generalized_sq_cases
			numpy/linalg/tests/test_linalg.py::TestDet::test_sq_cases
			"numpy/f2py/tests/test_return_character.py::TestFReturnCharacter::test_all_f77[s1]"
			"numpy/f2py/tests/test_return_character.py::TestFReturnCharacter::test_all_f77[t1]"
			"numpy/f2py/tests/test_return_character.py::TestFReturnCharacter::test_all_f90[s1]"
			"numpy/f2py/tests/test_return_character.py::TestFReturnCharacter::test_all_f90[t1]"
		)
	fi

	case ${EPYTHON} in
		python3.13)
			EPYTEST_DESELECT+=(
				numpy/_core/tests/test_nditer.py::test_iter_refcount
				numpy/_core/tests/test_limited_api.py::test_limited_api
				numpy/f2py/tests/test_f2py2e.py::test_gh22819_cli
			)
			;&
		python3.12)
			EPYTEST_DESELECT+=(
				# flaky
				numpy/f2py/tests/test_crackfortran.py
				numpy/f2py/tests/test_data.py::TestData::test_crackedlines
				numpy/f2py/tests/test_data.py::TestDataF77::test_crackedlines
				numpy/f2py/tests/test_f2py2e.py::test_gen_pyf
			)
			;;
	esac

	if ! has_version -b "~${CATEGORY}/${P}[${PYTHON_USEDEP}]" ; then
		# depends on importing numpy.random from system namespace
		EPYTEST_DESELECT+=(
			'numpy/random/tests/test_extending.py::test_cython'
		)
	fi

	if has_version ">=dev-python/setuptools-74[${PYTHON_USEDEP}]"; then
		# msvccompiler removal
		EPYTEST_DESELECT+=(
			numpy/tests/test_public_api.py::test_all_modules_are_expected_2
			numpy/tests/test_public_api.py::test_api_importable
		)
		EPYTEST_IGNORE+=(
			numpy/distutils/tests/test_mingw32ccompiler.py
			numpy/distutils/tests/test_system_info.py
		)
	fi

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	epytest
}

python_install_all() {
	local DOCS=( LICENSE.txt README.md THANKS.txt )
	distutils-r1_python_install_all
}
