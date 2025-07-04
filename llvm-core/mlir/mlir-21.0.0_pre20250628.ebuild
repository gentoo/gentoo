# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake llvm.org multilib-minimal python-any-r1

DESCRIPTION="Multi-Level Intermediate Representation (library only)"
HOMEPAGE="https://mlir.llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
IUSE="+debug test"
RESTRICT="!test? ( test )"

DEPEND="
	~llvm-core/llvm-${PV}[debug=,${MULTILIB_USEDEP}]
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
	llvm-core/llvm:${LLVM_MAJOR}
	test? (
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
	)
"

LLVM_COMPONENTS=( mlir cmake )
# tablegen tests use *.td files there
LLVM_TEST_COMPONENTS=( llvm/include )
llvm.org_set_globals

python_check_deps() {
	if use test; then
		python_has_version "dev-python/lit[${PYTHON_USEDEP}]"
	fi
}

src_prepare() {
	llvm.org_src_prepare

	# https://github.com/llvm/llvm-project/issues/120902
	sed -i -e '/LINK_LIBS/s:PUBLIC:PRIVATE:' \
		lib/ExecutionEngine/CMakeLists.txt || die
}

check_distribution_components() {
	if [[ ${CMAKE_MAKEFILE_GENERATOR} == ninja ]]; then
		local all_targets=() my_targets=() l
		cd "${BUILD_DIR}" || die

		while read -r l; do
			if [[ ${l} == install-*-stripped:* ]]; then
				l=${l#install-}
				l=${l%%-stripped*}

				case ${l} in
					# meta-targets
					mlir-libraries|distribution)
						continue
						;;
					# dylib
					MLIR)
						;;
					# installed test libraries
					MLIRTestAnalysis|MLIRTestDialect|MLIRTestIR)
						;;
					# static libraries
					MLIR*)
						continue
						;;
				esac

				all_targets+=( "${l}" )
			fi
		done < <(${NINJA} -t targets all)

		while read -r l; do
			my_targets+=( "${l}" )
		done < <(get_distribution_components $"\n")

		local add=() remove=()
		for l in "${all_targets[@]}"; do
			if ! has "${l}" "${my_targets[@]}"; then
				add+=( "${l}" )
			fi
		done
		for l in "${my_targets[@]}"; do
			if ! has "${l}" "${all_targets[@]}"; then
				remove+=( "${l}" )
			fi
		done

		if [[ ${#add[@]} -gt 0 || ${#remove[@]} -gt 0 ]]; then
			eqawarn "get_distribution_components() is outdated!"
			eqawarn "   Add: ${add[*]}"
			eqawarn "Remove: ${remove[*]}"
		fi
		cd - >/dev/null || die
	fi
}

get_distribution_components() {
	local sep=${1-;}

	local out=(
		mlir-cmake-exports
		mlir-headers

		# the dylib
		MLIR

		# shared libraries
		mlir_arm_runner_utils
		mlir_arm_sme_abi_stubs
		mlir_async_runtime
		mlir_c_runner_utils
		mlir_float16_utils
		mlir_runner_utils

		# test libraries required by flang
		MLIRTestAnalysis
		MLIRTestDialect
		MLIRTestIR
	)

	if multilib_is_native_abi; then
		out+=(
			# tools
			mlir-linalg-ods-yaml-gen
			mlir-lsp-server
			mlir-opt
			mlir-pdll
			mlir-pdll-lsp-server
			mlir-query
			mlir-reduce
			mlir-rewrite
			mlir-runner
			mlir-tblgen
			mlir-translate
			tblgen-lsp-server
			tblgen-to-irdl
		)
	fi

	printf "%s${sep}" "${out[@]}"
}

multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"
		-DLLVM_ROOT="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}"

		-DBUILD_SHARED_LIBS=OFF
		# this controls building libMLIR.so
		-DLLVM_BUILD_LLVM_DYLIB=ON
		-DMLIR_BUILD_MLIR_C_DYLIB=OFF
		-DMLIR_LINK_MLIR_DYLIB=ON
		-DMLIR_INCLUDE_TESTS=ON
		-DMLIR_INCLUDE_INTEGRATION_TESTS=OFF
		-DLLVM_DISTRIBUTION_COMPONENTS=$(get_distribution_components)
		# this enables installing mlir-tblgen and mlir-pdll
		-DLLVM_BUILD_UTILS=ON

		-DPython3_EXECUTABLE="${PYTHON}"

		-DLLVM_BUILD_TOOLS=ON
		# TODO
		-DMLIR_ENABLE_CUDA_RUNNER=0
		-DMLIR_ENABLE_ROCM_RUNNER=0
		-DMLIR_ENABLE_SYCL_RUNNER=0
		-DMLIR_ENABLE_SPIRV_CPU_RUNNER=0
		-DMLIR_ENABLE_VULKAN_RUNNER=0
		-DMLIR_ENABLE_BINDINGS_PYTHON=0
		-DMLIR_INSTALL_AGGREGATE_OBJECTS=OFF
	)
	use test && mycmakeargs+=(
		-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
		-DLLVM_LIT_ARGS="$(get_lit_flags)"
	)

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"
	cmake_src_configure

	multilib_is_native_abi && check_distribution_components
}

multilib_src_compile() {
	cmake_build distribution
}

multilib_src_test() {
	local known_xfail=()

	case ${ABI} in
		arm|ppc|x86)
			known_xfail+=(
				# MLIR is full of 64-bit assumptions, sigh
				# https://github.com/llvm/llvm-project/issues/124541
				Conversion/MemRefToLLVM/memref-to-llvm.mlir
				Dialect/Bufferization/Transforms/one-shot-bufferize-pass-statistics.mlir
				Dialect/LLVMIR/sroa-statistics.mlir
				Dialect/Linalg/vectorize-tensor-extract.mlir
				Dialect/MemRef/mem2reg-statistics.mlir
				Dialect/Tensor/fold-tensor-subset-ops.mlir
				Dialect/Tensor/tracking-listener.mlir
				Pass/pipeline-stats-nested.mlir
				Pass/pipeline-stats.mlir
			)
			;;
	esac

	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	local -x LIT_XFAIL="${known_xfail[*]}"
	LIT_XFAIL=${LIT_XFAIL// /;}
	cmake_build check-mlir
}

multilib_src_install() {
	DESTDIR=${D} cmake_build install-distribution
}
