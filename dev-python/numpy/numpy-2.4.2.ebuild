# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYPI_VERIFY_REPO=https://github.com/numpy/numpy-release
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )
PYTHON_REQ_USE="threads(+)"
FORTRAN_NEEDED=lapack

inherit distutils-r1 flag-o-matic fortran-2 pypi

DESCRIPTION="Fast array and numerical python library"
HOMEPAGE="
	https://numpy.org/
	https://github.com/numpy/numpy/
	https://pypi.org/project/numpy/
"

LICENSE="BSD 0BSD MIT ZLIB CC0-1.0"
SLOT="0/2"
if [[ ${PV} != *_rc* ]]; then
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
fi
# +lapack because the internal fallbacks are pretty slow. Building without blas
# is barely supported anyway, see bug #914358.
IUSE="big-endian +cpudetection index64 +lapack"

# upstream-flag[:gentoo-flag]
ARM_FLAGS=( neon{,-fp16} vfpv4 asimd{,hp,dp,fhm} sve )
PPC_FLAGS=( vsx vsx2 vsx3 vsx4 )
X86_FLAGS=(
	avx2 avx512{bw,dq,vl} avx512_{bf16,bitalg,fp16,vbmi2} sse4_2
)
IUSE+="
	${ARM_FLAGS[*]/#/cpu_flags_arm_}
	${PPC_FLAGS[*]/#/cpu_flags_ppc_}
	${X86_FLAGS[*]/#/cpu_flags_x86_}
"

RDEPEND="
	lapack? (
		>=virtual/cblas-3.8[index64(-)?]
		>=virtual/lapack-3.8[index64(-)?]
	)
"
BDEPEND="
	${RDEPEND}
	>=dev-build/meson-1.5.2
	>=dev-python/cython-3.0.6[${PYTHON_USEDEP}]
	lapack? (
		virtual/pkgconfig
	)
	test? (
		$(python_gen_cond_dep '
			>=dev-python/cffi-1.14.0[${PYTHON_USEDEP}]
		' 'python*')
		dev-python/charset-normalizer[${PYTHON_USEDEP}]
		>=dev-python/pytz-2019.3[${PYTHON_USEDEP}]
	)
"

QA_CONFIG_IMPL_DECL_SKIP=(
	# https://bugs.gentoo.org/925367
	vrndq_f32
)

EPYTEST_PLUGINS=( hypothesis pytest-timeout )
EPYTEST_XDIST=1
distutils_enable_tests pytest

has_all_x86() {
	local flag
	for flag; do
		if ! use "cpu_flags_x86_${flag}"; then
			return 1
		fi
	done
	return 0
}

python_configure_all() {
	local cpu_baseline=()
	local map flag
	case ${ARCH} in
		arm)
			# every flag implies the previous one
			for map in NEON:neon NEON_FP16:neon-fp16 NEON_VFPV4:vfpv4; do
				if ! use "cpu_flags_arm_${map#*:}"; then
					break
				fi
				cpu_baseline+=( "${map%:*}" )
			done
			;&
		arm64)
			# on 32-bit ARM, ASIMD implies all NEON* flags
			# on 64-bit ARM, they are all linked together
			if use arm64 ||
				[[ ${cpu_baseline[@]} && ${cpu_baseline[-1]} == NEON_VFPV4 ]]
			then
				cpu_baseline+=( $(usev cpu_flags_arm_asimd ASIMD) )
			fi

			# these two imply ASIMD
			if [[ ${cpu_baseline[@]} && ${cpu_baseline[-1]} == ASIMD ]]; then
				for flag in dp hp; do
					cpu_baseline+=(
						$(usev "cpu_flags_arm_asimd${flag}" "ASIMD${flag^^}")
					)
				done
			fi

			# these two imply ASIMDHP
			if [[ ${cpu_baseline[@]} && ${cpu_baseline[-1]} == ASIMDHP ]]; then
				for flag in asimdfhm sve; do
					cpu_baseline+=(
						$(usev "cpu_flags_arm_${flag}" "${flag^^}")
					)
				done
			fi
			;;
		ppc64)
			# every flag implies the previous one
			for flag in '' 2 3 4; do
				if ! use "cpu_flags_ppc_vsx${flags}"; then
					break
				fi
				cpu_baseline+=( "VSX${flag}" )
			done
			;;
		amd64|x86)
			# upstream combines multiple instructions into sets
			local mapping=(
				# for these, we just check the newest instruction set,
				# since all earlier instruction sets imply it
				"X86_V2=sse4_2"
				"X86_V3=avx2"
				# from here on, we check all features that were added
				# in the lowest CPU supporting them all
				# https://en.wikipedia.org/wiki/AVX-512
				"X86_V4=avx512bw avx512dq avx512vl"
				"AVX512_ICL=avx512_vbmi2 avx512_bitalg"
				"AVX512_SPR=avx512_bf16 avx512_fp16"
			)

			local m
			for m in "${mapping[@]}"; do
				local feature=${m%=*}
				local sets=${m#*=}

				if has_all_x86 ${sets}; then
					einfo "${feature} enabled: all of ${sets} enabled"
					cpu_baseline+=( "${feature}" )
				else
					einfo "${feature} disabled: not all of ${sets} enabled"
					break
				fi
			done
			;;
		*)
			cpu_baseline=MIN
			;;
	esac

	DISTUTILS_ARGS=(
		-Dallow-noblas=$(usex !lapack true false)
		-Duse-ilp64=$(usex index64 true false)
		-Dblas=$(usev lapack $(usex index64 cblas64 cblas))
		-Dlapack=$(usev lapack $(usex index64 lapack64 lapack))
		-Dcpu-baseline="${cpu_baseline[*]}"
		-Dcpu-baseline-detect=disabled
		-Dcpu-dispatch="$(usev cpudetection MAX)"
	)

	# bug #922457
	filter-lto
	# https://github.com/numpy/numpy/issues/25004
	append-flags -fno-strict-aliasing
}

python_test() {
	# We run tests in parallel, so avoid having n^2 threads in lapack
	# tests.
	local -x BLIS_NUM_THREADS=1
	local -x MKL_NUM_THREADS=1
	local -x OMP_NUM_THREADS=1
	local -x OPENBLAS_NUM_THREADS=1

	# don't run tests that require more than 2 GiB of RAM (per process)
	local -x NPY_AVAILABLE_MEM="2 GiB"

	local EPYTEST_DESELECT=(
		# Very disk-and-memory-hungry
		numpy/lib/tests/test_io.py::TestSavezLoad::test_closing_fid
		numpy/lib/tests/test_io.py::TestSavezLoad::test_closing_zipfile_after_load

		# Precision problems
		numpy/_core/tests/test_umath_accuracy.py::TestAccuracy::test_validate_transcendentals

		numpy/typing/tests/test_typing.py

		# Flaky, reruns don't help
		numpy/f2py/tests/test_crackfortran.py
		numpy/f2py/tests/test_data.py::TestData{,F77}::test_crackedlines
		numpy/f2py/tests/test_f2py2e.py::test_gen_pyf
		numpy/f2py/tests/test_f2py2e.py::test_gh22819_cli
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
				numpy/f2py/tests/test_kind.py::TestKind::test_quad_precision

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
				"numpy/_core/tests/test_dtype.py::TestBuiltin::test_dtype_bytes_str_equivalence[datetime64]"
				"numpy/_core/tests/test_dtype.py::TestBuiltin::test_dtype_bytes_str_equivalence[timedelta64]"
				"numpy/_core/tests/test_dtype.py::TestBuiltin::test_dtype_bytes_str_equivalence[<f]"
				"numpy/_core/tests/test_dtype.py::TestPickling::test_pickle_dtype[dt28]"
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

	cd "${BUILD_DIR}/install$(python_get_sitedir)" || die
	epytest
}

python_install_all() {
	local DOCS=( LICENSE.txt README.md THANKS.txt )
	distutils-r1_python_install_all
}
