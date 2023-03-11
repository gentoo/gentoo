# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
inherit flag-o-matic cmake-multilib linux-info llvm llvm.org
inherit python-single-r1 toolchain-funcs

DESCRIPTION="OpenMP runtime library for LLVM/clang compiler"
HOMEPAGE="https://openmp.llvm.org"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="0/${LLVM_SOABI}"
KEYWORDS=""
IUSE="
	debug gdb-plugin hwloc offload ompt test
	llvm_targets_AMDGPU llvm_targets_NVPTX
"
REQUIRED_USE="
	gdb-plugin? ( ${PYTHON_REQUIRED_USE} )
"
RESTRICT="!test? ( test )"

RDEPEND="
	gdb-plugin? ( ${PYTHON_DEPS} )
	hwloc? ( >=sys-apps/hwloc-2.5:0=[${MULTILIB_USEDEP}] )
	offload? (
		dev-libs/libffi:=[${MULTILIB_USEDEP}]
		~sys-devel/llvm-${PV}[${MULTILIB_USEDEP}]
		llvm_targets_AMDGPU? ( dev-libs/rocr-runtime:= )
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
		${PYTHON_DEPS}
		$(python_gen_cond_dep '
			dev-python/lit[${PYTHON_USEDEP}]
		')
		sys-devel/clang
	)
"

LLVM_COMPONENTS=( openmp cmake llvm/include )
llvm.org_set_globals

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
	use offload && LLVM_MAX_SLOT=${LLVM_MAJOR} llvm_pkg_setup
	if use gdb-plugin || use test; then
		python-single-r1_pkg_setup
	fi
}

multilib_src_configure() {
	# LTO causes issues in other packages building, #870127
	filter-lto

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	local build_omptarget=OFF
	# upstream disallows building libomptarget when sizeof(void*) != 8
	if use offload &&
		"$(tc-getCC)" ${CFLAGS} ${CPPFLAGS} -c -x c - -o /dev/null \
		<<-EOF &>/dev/null
			int test[sizeof(void *) == 8 ? 1 : -1];
		EOF
	then
		build_omptarget=ON
	fi

	local libdir="$(get_libdir)"
	local mycmakeargs=(
		-DOPENMP_LIBDIR_SUFFIX="${libdir#lib}"

		-DLIBOMP_USE_HWLOC=$(usex hwloc)
		-DLIBOMP_OMPD_GDB_SUPPORT=$(multilib_native_usex gdb-plugin)
		-DLIBOMP_OMPT_SUPPORT=$(usex ompt)

		-DOPENMP_ENABLE_LIBOMPTARGET=${build_omptarget}

		# do not install libgomp.so & libiomp5.so aliases
		-DLIBOMP_INSTALL_ALIASES=OFF
		# disable unnecessary hack copying stuff back to srcdir
		-DLIBOMP_COPY_EXPORTS=OFF
	)

	if [[ ${build_omptarget} == ON ]]; then
		if has "${CHOST%%-*}" aarch64 powerpc64le x86_64; then
			mycmakeargs+=(
				-DLIBOMPTARGET_BUILD_AMDGPU_PLUGIN=$(usex llvm_targets_AMDGPU)
				-DLIBOMPTARGET_BUILD_CUDA_PLUGIN=$(usex llvm_targets_NVPTX)
			)
		else
			mycmakeargs+=(
				-DLIBOMPTARGET_BUILD_AMDGPU_PLUGIN=OFF
				-DLIBOMPTARGET_BUILD_CUDA_PLUGIN=OFF
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
