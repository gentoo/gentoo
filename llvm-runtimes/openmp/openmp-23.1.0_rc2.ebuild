# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake-multilib crossdev flag-o-matic llvm.org python-single-r1
inherit toolchain-funcs

DESCRIPTION="OpenMP runtime libraries for LLVM/clang compiler"
HOMEPAGE="https://openmp.llvm.org"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0/${LLVM_SOABI}"
IUSE="
	+clang +debug gdb-plugin hwloc offload ompt test
	cuda level-zero rocm
"
REQUIRED_USE="
	gdb-plugin? ( ${PYTHON_REQUIRED_USE} )
"
RESTRICT="!test? ( test )"

DEPEND="
	hwloc? ( >=sys-apps/hwloc-2.5:0=[${MULTILIB_USEDEP}] )
	offload? (
		dev-libs/libffi:=
		~llvm-core/llvm-${PV}
		level-zero? ( dev-libs/level-zero:= )
		rocm? ( dev-libs/rocr-runtime:= )
	)
"
# tests:
# - dev-python/lit provides the test runner
# - llvm-core/llvm provide test utils (e.g. FileCheck)
# - llvm-core/clang provides the compiler to run tests
RDEPEND="
	${DEPEND}
	gdb-plugin? ( ${PYTHON_DEPS} )
	offload? (
		!llvm-runtimes/offload
		cuda? ( ~llvm-runtimes/openmp-nvptx64-nvidia-cuda-${PV} )
		level-zero? ( ~llvm-runtimes/openmp-spirv64-intel-${PV} )
		rocm? ( ~llvm-runtimes/openmp-amdgcn-amd-amdhsa-${PV} )
	)
"
BDEPEND="
	dev-lang/perl
	clang? ( llvm-core/clang )
	gdb-plugin? ( ${PYTHON_DEPS} )
	offload? (
		virtual/pkgconfig
	)
	test? (
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/lit[${PYTHON_USEDEP}]
		')
		llvm-core/clang:${LLVM_MAJOR}
		llvm-core/llvm:${LLVM_MAJOR}
	)
"

LLVM_COMPONENTS=(
	runtimes openmp offload cmake libc llvm/{cmake,include,utils}
	third-party/unittest
)
llvm.org_set_globals

MULTILIB_WRAPPED_HEADERS=(
	/usr/include/offload/OffloadPrint.hpp
	/usr/include/offload/OffloadAPI.h
)

pkg_pretend() {
	if [[ ${LLVM_ALLOW_GPU_TESTING} ]]; then
		ewarn "LLVM_ALLOW_GPU_TESTING set.  This package will run tests against your"
		ewarn "GPU if it is supported.  Note that these tests may be flaky, fail or"
		ewarn "hang, or even cause your GPU to crash (requiring a reboot)."
	fi
}

pkg_setup() {
	if use gdb-plugin || use test; then
		python-single-r1_pkg_setup
	fi
}

multilib_src_configure() {
	if use clang && ! is_crosspkg; then
		# Only do this conditionally to allow overriding with
		# e.g. CC=clang-13 in case of breakage
		if ! tc-is-clang ; then
			local -x CC=${CHOST}-clang
			local -x CXX=${CHOST}-clang++
		fi

		strip-unsupported-flags
	fi

	# LTO causes issues in other packages building, #870127
	filter-lto

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	local libdir="$(get_libdir)"
	local mycmakeargs=(
		-DLLVM_ENABLE_RUNTIMES=openmp
		-DLLVM_LIBDIR_SUFFIX="${libdir#lib}"
		-DLLVM_BINARY_DIR="${BROOT}/usr/lib/llvm/${LLVM_MAJOR}"

		-DLIBOMP_USE_HWLOC=$(usex hwloc)
		-DLIBOMP_OMPD_GDB_SUPPORT=$(multilib_native_usex gdb-plugin)
		-DLIBOMP_OMPT_SUPPORT=$(usex ompt)

		# do not install libgomp.so & libiomp5.so aliases
		-DLIBOMP_INSTALL_ALIASES=OFF
		# disable unnecessary hack copying stuff back to srcdir
		-DLIBOMP_COPY_EXPORTS=OFF
		# this breaks building static target libs
		-DBUILD_SHARED_LIBS=OFF
	)

	if multilib_is_native_abi && use offload; then
		local ffi_cflags=$($(tc-getPKG_CONFIG) --cflags-only-I libffi)
		local ffi_ldflags=$($(tc-getPKG_CONFIG) --libs-only-L libffi)
		local plugins="host"

		if has "${CHOST%%-*}" aarch64 powerpc64le x86_64; then
			if use rocm; then
				plugins+=";amdgpu"
			fi
			if use cuda; then
				plugins+=";cuda"
			fi
			if use level-zero; then
				plugins+=";level_zero"
			fi
		fi

		mycmakeargs+=(
			-DLLVM_ENABLE_RUNTIMES="openmp;offload"
			-DOFFLOAD_INCLUDE_TESTS=$(usex test)
			-DLIBOMPTARGET_PLUGINS_TO_BUILD="${plugins}"
			-DLIBOMPTARGET_OMPT_SUPPORT="$(usex ompt)"
		)

		[[ ! ${LLVM_ALLOW_GPU_TESTING} ]] && mycmakeargs+=(
			# prevent trying to access the GPU
			-DLIBOMPTARGET_AMDGPU_ARCH=LIBOMPTARGET_AMDGPU_ARCH-NOTFOUND
			-DLIBOMPTARGET_NVPTX_ARCH=LIBOMPTARGET_NVPTX_ARCH-NOTFOUND
			-DLIBOMPTARGET_OFFLOAD_ARCH=LIBOMPTARGET_OFFLOAD_ARCH-NOTFOUND
		)
	fi

	use test && mycmakeargs+=(
		-DLLVM_LIT_ARGS="$(get_lit_flags)"
		-DOPENMP_TEST_C_COMPILER="$(type -P "${CHOST}-clang-${LLVM_MAJOR}")"
		-DOPENMP_TEST_CXX_COMPILER="$(type -P "${CHOST}-clang++-${LLVM_MAJOR}")"
		# disable Fortran tests for now
		# (TODO: enable where we have flang keyworded)
		-DOPENMP_TEST_Fortran_COMPILER=
	)
	cmake_src_configure
}

multilib_src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	local targets=( check-openmp )
	if multilib_is_native_abi && use offload; then
		targets+=( check-offload check-offload-unit )
	fi

	cmake_build "${targets[@]}"
}
