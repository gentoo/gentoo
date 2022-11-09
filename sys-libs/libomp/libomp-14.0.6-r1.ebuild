# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit flag-o-matic cmake-multilib linux-info llvm llvm.org python-any-r1

DESCRIPTION="OpenMP runtime library for LLVM/clang compiler"
HOMEPAGE="https://openmp.llvm.org"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv x86 ~amd64-linux ~x64-macos"
IUSE="
	cuda debug hwloc offload ompt test
	llvm_targets_AMDGPU llvm_targets_NVPTX
"
RESTRICT="!test? ( test )"
# CUDA works only with the x86_64 ABI
REQUIRED_USE="
	cuda? ( llvm_targets_NVPTX )
	offload? ( cuda? ( abi_x86_64 ) )
"

RDEPEND="
	hwloc? ( >=sys-apps/hwloc-2.5:0=[${MULTILIB_USEDEP}] )
	offload? (
		virtual/libelf:=[${MULTILIB_USEDEP}]
		dev-libs/libffi:=[${MULTILIB_USEDEP}]
		~sys-devel/llvm-${PV}[${MULTILIB_USEDEP}]
		cuda? ( dev-util/nvidia-cuda-toolkit:= )
	)
"
# tests:
# - dev-python/lit provides the test runner
# - sys-devel/llvm provide test utils (e.g. FileCheck)
# - sys-devel/clang provides the compiler to run tests
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-lang/perl
	offload? (
		llvm_targets_AMDGPU? ( sys-devel/clang )
		llvm_targets_NVPTX? ( sys-devel/clang )
		virtual/pkgconfig
	)
	test? (
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
		sys-devel/clang
	)
"

LLVM_COMPONENTS=( openmp llvm/include )
LLVM_PATCHSET=${PV}-r2
llvm.org_set_globals

python_check_deps() {
	python_has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

kernel_pds_check() {
	if use kernel_linux && kernel_is -lt 4 15 && kernel_is -ge 4 13; then
		local CONFIG_CHECK="~!SCHED_PDS"
		local ERROR_SCHED_PDS="\
PDS scheduler versions >= 0.98c < 0.98i (e.g. used in kernels >= 4.13-pf11
< 4.14-pf9) do not implement sched_yield() call which may result in horrible
performance problems with libomp. If you are using one of the specified
kernel versions, you may want to disable the PDS scheduler."

		check_extra_config
	fi
}

pkg_pretend() {
	kernel_pds_check
}

pkg_setup() {
	use offload && LLVM_MAX_SLOT=${PV%%.*} llvm_pkg_setup
	use test && python-any-r1_pkg_setup
}

multilib_src_configure() {
	# LTO causes issues in other packages building, #870127
	filter-lto

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	local libdir="$(get_libdir)"
	local mycmakeargs=(
		-DOPENMP_LIBDIR_SUFFIX="${libdir#lib}"

		-DLIBOMP_USE_HWLOC=$(usex hwloc)
		-DLIBOMP_OMPT_SUPPORT=$(usex ompt)

		-DOPENMP_ENABLE_LIBOMPTARGET=$(usex offload)

		# do not install libgomp.so & libiomp5.so aliases
		-DLIBOMP_INSTALL_ALIASES=OFF
		# disable unnecessary hack copying stuff back to srcdir
		-DLIBOMP_COPY_EXPORTS=OFF
	)

	if use offload; then
		if has "${CHOST%%-*}" aarch64 powerpc64le x86_64; then
			mycmakeargs+=(
				-DCMAKE_DISABLE_FIND_PACKAGE_CUDA=$(usex !cuda)
				-DLIBOMPTARGET_BUILD_AMDGCN_BCLIB=$(usex llvm_targets_AMDGPU)
				-DLIBOMPTARGET_BUILD_NVPTX_BCLIB=$(usex llvm_targets_NVPTX)
				# a cheap hack to force clang
				-DLIBOMPTARGET_NVPTX_CUDA_COMPILER="$(type -P "${CHOST}-clang")"
				# upstream defaults to looking for it in clang dir
				# this fails when ccache is being used
				-DLIBOMPTARGET_NVPTX_BC_LINKER="$(type -P llvm-link)"
			)
		else
			mycmakeargs+=(
				-DCMAKE_DISABLE_FIND_PACKAGE_CUDA=ON
				-DLIBOMPTARGET_BUILD_AMDGCN_BCLIB=OFF
				-DLIBOMPTARGET_BUILD_NVPTX_BCLIB=OFF
			)
		fi
	fi

	use test && mycmakeargs+=(
		# this project does not use standard LLVM cmake macros
		-DOPENMP_LLVM_LIT_EXECUTABLE="${EPREFIX}/usr/bin/lit"
		-DOPENMP_LIT_ARGS="$(get_lit_flags)"

		-DOPENMP_TEST_C_COMPILER="$(type -P "${CHOST}-clang")"
		-DOPENMP_TEST_CXX_COMPILER="$(type -P "${CHOST}-clang++")"
	)
	addpredict /dev/nvidiactl
	cmake_src_configure
}

multilib_src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1

	cmake_build check-libomp
}
