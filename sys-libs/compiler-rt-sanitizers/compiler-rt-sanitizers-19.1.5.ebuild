# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit check-reqs cmake flag-o-matic llvm.org llvm-utils python-any-r1

DESCRIPTION="Compiler runtime libraries for clang (sanitizers & xray)"
HOMEPAGE="https://llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="${LLVM_MAJOR}"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc64 ~riscv ~x86 ~amd64-linux ~ppc-macos ~x64-macos"
IUSE="+abi_x86_32 abi_x86_64 +clang debug test"
# base targets
IUSE+=" +ctx-profile +libfuzzer +memprof +orc +profile +xray"
# sanitizer targets, keep in sync with config-ix.cmake
# NB: ubsan, scudo deliberately match two entries
SANITIZER_FLAGS=(
	asan dfsan lsan msan hwasan tsan ubsan safestack cfi scudo
	shadowcallstack gwp-asan
)
IUSE+=" ${SANITIZER_FLAGS[@]/#/+}"
REQUIRED_USE="
	|| ( ${SANITIZER_FLAGS[*]} libfuzzer orc profile xray )
	test? (
		cfi? ( ubsan )
		gwp-asan? ( scudo )
	)
"
RESTRICT="
	!clang? ( test )
	!test? ( test )
"

DEPEND="
	sys-devel/llvm:${LLVM_MAJOR}
	virtual/libcrypt[abi_x86_32(-)?,abi_x86_64(-)?]
"
BDEPEND="
	clang? (
		sys-devel/clang:${LLVM_MAJOR}
		sys-libs/compiler-rt:${LLVM_MAJOR}
	)
	elibc_glibc? ( net-libs/libtirpc )
	test? (
		$(python_gen_any_dep ">=dev-python/lit-15[\${PYTHON_USEDEP}]")
		=sys-devel/clang-${LLVM_VERSION}*:${LLVM_MAJOR}
	)
	!test? (
		${PYTHON_DEPS}
	)
"

LLVM_COMPONENTS=( compiler-rt cmake llvm/cmake )
LLVM_TEST_COMPONENTS=(
	llvm/include/llvm/ProfileData llvm/lib/Testing/Support third-party
)
llvm.org_set_globals

python_check_deps() {
	use test || return 0
	python_has_version ">=dev-python/lit-15[${PYTHON_USEDEP}]"
}

check_space() {
	if use test; then
		local CHECKREQS_DISK_BUILD=11G
		check-reqs_pkg_pretend
	fi
}

pkg_pretend() {
	check_space
}

pkg_setup() {
	check_space
	python-any-r1_pkg_setup
}

src_prepare() {
	sed -i -e 's:-Werror::' lib/tsan/go/buildgo.sh || die

	local flag
	for flag in "${SANITIZER_FLAGS[@]}"; do
		if ! use "${flag}"; then
			local cmake_flag=${flag/-/_}
			sed -i -e "/COMPILER_RT_HAS_${cmake_flag^^}/s:TRUE:FALSE:" \
				cmake/config-ix.cmake || die
		fi
	done

	# TODO: fix these tests to be skipped upstream
	if use asan && ! use profile; then
		rm test/asan/TestCases/asan_and_llvm_coverage_test.cpp || die
	fi
	if use ubsan && ! use cfi; then
		> test/cfi/CMakeLists.txt || die
	fi
	# hangs, sigh
	rm test/tsan/getline_nohang.cpp || die

	llvm.org_src_prepare
}

src_configure() {
	llvm_prepend_path "${LLVM_MAJOR}"

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	# pre-set since we need to pass it to cmake
	BUILD_DIR=${WORKDIR}/compiler-rt_build

	if use clang; then
		local -x CC=${CHOST}-clang
		local -x CXX=${CHOST}-clang++
		strip-unsupported-flags
	fi

	local flag want_sanitizer=OFF
	for flag in "${SANITIZER_FLAGS[@]}"; do
		if use "${flag}"; then
			want_sanitizer=ON
			break
		fi
	done

	local mycmakeargs=(
		-DCOMPILER_RT_INSTALL_PATH="${EPREFIX}/usr/lib/clang/${LLVM_MAJOR}"
		# use a build dir structure consistent with install
		# this makes it possible to easily deploy test-friendly clang
		-DCOMPILER_RT_OUTPUT_DIR="${BUILD_DIR}/lib/clang/${LLVM_MAJOR}"

		-DCOMPILER_RT_INCLUDE_TESTS=$(usex test)
		# builtins & crt installed by sys-libs/compiler-rt
		-DCOMPILER_RT_BUILD_BUILTINS=OFF
		-DCOMPILER_RT_BUILD_CRT=OFF
		-DCOMPILER_RT_BUILD_CTX_PROFILE=$(usex ctx-profile)
		-DCOMPILER_RT_BUILD_LIBFUZZER=$(usex libfuzzer)
		-DCOMPILER_RT_BUILD_MEMPROF=$(usex memprof)
		-DCOMPILER_RT_BUILD_ORC=$(usex orc)
		-DCOMPILER_RT_BUILD_PROFILE=$(usex profile)
		-DCOMPILER_RT_BUILD_SANITIZERS="${want_sanitizer}"
		-DCOMPILER_RT_BUILD_XRAY=$(usex xray)

		-DPython3_EXECUTABLE="${PYTHON}"
	)

	if use amd64; then
		mycmakeargs+=(
			-DCAN_TARGET_i386=$(usex abi_x86_32)
			-DCAN_TARGET_x86_64=$(usex abi_x86_64)
		)
	fi

	if use test; then
		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="$(get_lit_flags)"

			# they are created during src_test()
			-DCOMPILER_RT_TEST_COMPILER="${BUILD_DIR}/lib/llvm/${LLVM_MAJOR}/bin/clang"
			-DCOMPILER_RT_TEST_CXX_COMPILER="${BUILD_DIR}/lib/llvm/${LLVM_MAJOR}/bin/clang++"
		)

		# same flags are passed for build & tests, so we need to strip
		# them down to a subset supported by clang
		CC=${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/bin/clang \
		CXX=${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/bin/clang++ \
		strip-unsupported-flags
	fi

	if use prefix && [[ "${CHOST}" == *-darwin* ]] ; then
		mycmakeargs+=(
			# setting -isysroot is disabled with compiler-rt-prefix-paths.patch
			# this allows adding arm64 support using SDK in EPREFIX
			-DDARWIN_macosx_CACHED_SYSROOT="${EPREFIX}/MacOSX.sdk"
			# Set version based on the SDK in EPREFIX
			# This disables i386 for SDK >= 10.15
			# Will error if has_use tsan and SDK < 10.12
			-DDARWIN_macosx_OVERRIDE_SDK_VERSION="$(realpath ${EPREFIX}/MacOSX.sdk | sed -e 's/.*MacOSX\(.*\)\.sdk/\1/')"
			# Use our libtool instead of looking it up with xcrun
			-DCMAKE_LIBTOOL="${EPREFIX}/usr/bin/${CHOST}-libtool"
		)
	fi

	cmake_src_configure

	if use test; then
		local sys_dir=( "${EPREFIX}"/usr/lib/clang/${LLVM_MAJOR}/lib/* )
		[[ -e ${sys_dir} ]] || die "Unable to find ${sys_dir}"
		[[ ${#sys_dir[@]} -eq 1 ]] || die "Non-deterministic compiler-rt install: ${sys_dir[*]}"

		# copy clang over since resource_dir is located relatively to binary
		# therefore, we can put our new libraries in it
		mkdir -p "${BUILD_DIR}"/lib/{llvm/${LLVM_MAJOR}/{bin,$(get_libdir)},clang/${LLVM_MAJOR}/include} || die
		cp "${EPREFIX}"/usr/lib/llvm/${LLVM_MAJOR}/bin/clang{,++} \
			"${BUILD_DIR}"/lib/llvm/${LLVM_MAJOR}/bin/ || die
		cp "${EPREFIX}"/usr/lib/clang/${LLVM_MAJOR}/include/*.h \
			"${BUILD_DIR}"/lib/clang/${LLVM_MAJOR}/include/ || die
		cp "${sys_dir}"/*builtins*.a \
			"${BUILD_DIR}/lib/clang/${LLVM_MAJOR}/lib/${sys_dir##*/}/" || die
		# we also need LLVMgold.so for gold-based tests
		if [[ -f ${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/$(get_libdir)/LLVMgold.so ]]; then
			ln -s "${EPREFIX}"/usr/lib/llvm/${LLVM_MAJOR}/$(get_libdir)/LLVMgold.so \
				"${BUILD_DIR}"/lib/llvm/${LLVM_MAJOR}/$(get_libdir)/ || die
		fi
	fi
}

src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1
	# disable sandbox to have it stop clobbering LD_PRELOAD
	local -x SANDBOX_ON=0
	# wipe LD_PRELOAD to make ASAN happy
	local -x LD_PRELOAD=

	cmake_build check-all
}
