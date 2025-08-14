# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
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

LICENSE="BSD"
SLOT="0/2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
# +lapack because the internal fallbacks are pretty slow. Building without blas
# is barely supported anyway, see bug #914358.
IUSE="big-endian +cpudetection +lapack"

# upstream-flag[:gentoo-flag]
ARM_FLAGS=( neon{,-fp16} vfpv4 asimd{,hp,dp,fhm} sve )
PPC_FLAGS=( vsx vsx2 vsx3 vsx4 )
X86_FLAGS=(
	sse{,2,3,4_1,4_2} ssse3 popcnt avx{,2} xop fma{3,4}
	f16c avx512{f,cd,pf,er,dq,bw,vl,ifma,vbmi}
	avx512_{vpopcntdq,4vnniw,4fmaps,vbmi2,bitalg,fp16,vnni}
)
IUSE+="
	${ARM_FLAGS[*]/#/cpu_flags_arm_}
	${PPC_FLAGS[*]/#/cpu_flags_ppc_}
	${X86_FLAGS[*]/#/cpu_flags_x86_}
"

RDEPEND="
	lapack? (
		>=virtual/cblas-3.8
		>=virtual/lapack-3.8
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

PATCHES=(
	# https://github.com/numpy/numpy/pull/29459
	"${FILESDIR}"/${P}-no-detect.patch
)

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
						$(usex "cpu_flags_arm_asimd${flag}" "ASIMD${flag^^}")
					)
				done
			fi

			# these two imply ASIMDHP
			if [[ ${cpu_baseline[@]} && ${cpu_baseline[-1]} == ASIMDHP ]]; then
				for flag in asimdfhm sve; do
					cpu_baseline+=(
						$(usex "cpu_flags_arm_${flag}" "${flag^^}")
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
			# every flag implies the previous one
			for flag in sse{,2,3} ssse3 sse4_1 popcnt sse4_2 avx; do
				if ! use "cpu_flags_x86_${flag}"; then
					break
				fi
				flag=${flag/_}
				cpu_baseline+=( "${flag^^}" )
			done

			# these imply AVX
			if [[ ${cpu_baseline[@]} && ${cpu_baseline[-1]} == AVX ]]; then
				for flag in xop fma4 f16c; do
					if use "cpu_flags_x86_${flag}"; then
						cpu_baseline+=( "${flag^^}" )
					fi
				done
			fi

			# another chain started on implying F16C
			if [[ ${cpu_baseline[@]} && ${cpu_baseline[-1]} == F16C ]]; then
				for flag in fma3 avx2 avx512f avx512cd; do
					if ! use "cpu_flags_x86_${flag}"; then
						break
					fi
					cpu_baseline+=( "${flag^^}" )
				done
			fi

			if [[ ${cpu_baseline[@]} && ${cpu_baseline[-1]} == AVX512CD ]]; then
				# upstream combines multiple instructions into per-CPU sets
				local avx512_mapping=(
					"AVX512_KNL:avx512pf avx512er"
					"AVX512_KNM:avx512_vpopcntdq avx512_4vnniw avx512_4fmaps"
					"AVX512_SKX:avx512dq avx512bw avx512vl"
					"AVX512_CLX:avx512_vnni"
					"AVX512_CNL:avx512ifma avx512vbmi"
					"AVX512_ICL:avx512_vbmi2 avx512_bitalg"
					"AVX512_SPR:avx512_fp16"
				)
				for map in "${avx512_mapping[@]}"; do
					for flag in ${map#*:}; do
						if ! use "cpu_flags_x86_${flag}"; then
							break 2
						fi
					done
					cpu_baseline+=( "${map%:*}" )
				done
			fi
			;;
		*)
			cpu_baseline=MIN
			;;
	esac

	DISTUTILS_ARGS=(
		-Dallow-noblas=$(usex !lapack true false)
		-Dblas=$(usev lapack cblas)
		-Dlapack=$(usev lapack lapack)
		-Dcpu-baseline="${cpu_baseline[*]}"
		-Dcpu-baseline-detect=disabled
		# '-XOP -FMA4' is upstream default, since these are deprecated
		-Dcpu-dispatch="$(usev cpudetection 'MAX -XOP -FMA4')"
	)

	# bug #922457
	filter-lto
	# https://github.com/numpy/numpy/issues/25004
	append-flags -fno-strict-aliasing
}

python_test() {
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
		numpy/f2py/tests/test_f2py2e.py::test_gh22819_cli
		numpy/f2py/tests/test_data.py::TestDataF77::test_crackedlines
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
