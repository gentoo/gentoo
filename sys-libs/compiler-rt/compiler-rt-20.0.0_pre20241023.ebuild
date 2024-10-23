# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
inherit cmake crossdev flag-o-matic llvm.org llvm-utils python-any-r1
inherit toolchain-funcs

DESCRIPTION="Compiler runtime library for clang (built-in part)"
HOMEPAGE="https://llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions || ( UoI-NCSA MIT )"
SLOT="${LLVM_MAJOR}"
IUSE="+abi_x86_32 abi_x86_64 +clang +debug test"
RESTRICT="!test? ( test ) !clang? ( test )"

DEPEND="
	sys-devel/llvm:${LLVM_MAJOR}
"
BDEPEND="
	clang? ( sys-devel/clang:${LLVM_MAJOR} )
	test? (
		$(python_gen_any_dep ">=dev-python/lit-15[\${PYTHON_USEDEP}]")
		=sys-devel/clang-${LLVM_VERSION}*:${LLVM_MAJOR}
	)
	!test? (
		${PYTHON_DEPS}
	)
"

LLVM_COMPONENTS=( compiler-rt cmake llvm/cmake )
LLVM_TEST_COMPONENTS=( llvm/include/llvm/TargetParser )
llvm.org_set_globals

python_check_deps() {
	use test || return 0
	python_has_version ">=dev-python/lit-15[${PYTHON_USEDEP}]"
}

pkg_pretend() {
	if ! use clang && ! tc-is-clang; then
		ewarn "Building using a compiler other than clang may result in broken atomics"
		ewarn "library. Enable USE=clang unless you have a very good reason not to."
	fi
}

pkg_setup() {
	if target_is_not_host || tc-is-cross-compiler ; then
		# strips vars like CFLAGS="-march=x86_64-v3" for non-x86 architectures
		CHOST=${CTARGET} strip-unsupported-flags
		# overrides host docs otherwise
		DOCS=()
	fi
	python-any-r1_pkg_setup
}

test_compiler() {
	target_is_not_host && return
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} "${@}" -o /dev/null -x c - \
		<<<'int main() { return 0; }' &>/dev/null
}

src_configure() {
	llvm_prepend_path "${LLVM_MAJOR}"

	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	# pre-set since we need to pass it to cmake
	BUILD_DIR=${WORKDIR}/${P}_build

	if use clang && ! is_crosspkg; then
		# Only do this conditionally to allow overriding with
		# e.g. CC=clang-13 in case of breakage
		if ! tc-is-clang ; then
			local -x CC=${CHOST}-clang
			local -x CXX=${CHOST}-clang++
		fi

		strip-unsupported-flags
	fi

	if ! is_crosspkg && ! test_compiler ; then
		local nolib_flags=( -nodefaultlibs -lc )

		if test_compiler "${nolib_flags[@]}"; then
			local -x LDFLAGS="${LDFLAGS} ${nolib_flags[*]}"
			ewarn "${CC} seems to lack runtime, trying with ${nolib_flags[*]}"
		elif test_compiler "${nolib_flags[@]}" -nostartfiles; then
			# Avoiding -nostartfiles earlier on for bug #862540,
			# and set available entry symbol for bug #862798.
			nolib_flags+=( -nostartfiles -e main )

			local -x LDFLAGS="${LDFLAGS} ${nolib_flags[*]}"
			ewarn "${CC} seems to lack runtime, trying with ${nolib_flags[*]}"
		fi
	fi

	local mycmakeargs=(
		-DCOMPILER_RT_INSTALL_PATH="${EPREFIX}/usr/lib/clang/${LLVM_MAJOR}"

		-DCOMPILER_RT_INCLUDE_TESTS=$(usex test)
		-DCOMPILER_RT_BUILD_CTX_PROFILE=OFF
		-DCOMPILER_RT_BUILD_LIBFUZZER=OFF
		-DCOMPILER_RT_BUILD_MEMPROF=OFF
		-DCOMPILER_RT_BUILD_ORC=OFF
		-DCOMPILER_RT_BUILD_PROFILE=OFF
		-DCOMPILER_RT_BUILD_SANITIZERS=OFF
		-DCOMPILER_RT_BUILD_XRAY=OFF

		-DPython3_EXECUTABLE="${PYTHON}"
	)

	if use amd64 && ! target_is_not_host; then
		mycmakeargs+=(
			-DCAN_TARGET_i386=$(usex abi_x86_32)
			-DCAN_TARGET_x86_64=$(usex abi_x86_64)
		)
	fi

	if is_crosspkg; then
		# Needed to target built libc headers
		export CFLAGS="${CFLAGS} -isystem /usr/${CTARGET}/usr/include"
		mycmakeargs+=(
			# Without this, the compiler will compile a test program
			# and fail due to no builtins.
			-DCMAKE_C_COMPILER_WORKS=1
			-DCMAKE_CXX_COMPILER_WORKS=1

			# Without this, compiler-rt install location is not unique
			# to target triples, only to architecture.
			# Needed if you want to target multiple libcs for one arch.
			-DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR=ON

			-DCMAKE_ASM_COMPILER_TARGET="${CTARGET}"
			-DCMAKE_C_COMPILER_TARGET="${CTARGET}"
			-DCOMPILER_RT_DEFAULT_TARGET_ONLY=ON
		)
	fi

	if use prefix && [[ "${CHOST}" == *-darwin* ]] ; then
		mycmakeargs+=(
			# setting -isysroot is disabled with compiler-rt-prefix-paths.patch
			# this allows adding arm64 support using SDK in EPREFIX
			-DDARWIN_macosx_CACHED_SYSROOT="${EPREFIX}/MacOSX.sdk"
			# Set version based on the SDK in EPREFIX.
			# This disables i386 for SDK >= 10.15
			-DDARWIN_macosx_OVERRIDE_SDK_VERSION="$(realpath ${EPREFIX}/MacOSX.sdk | sed -e 's/.*MacOSX\(.*\)\.sdk/\1/')"
			# Use our libtool instead of looking it up with xcrun
			-DCMAKE_LIBTOOL="${EPREFIX}/usr/bin/${CHOST}-libtool"
		)
	fi

	if use test; then
		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="$(get_lit_flags)"

			-DCOMPILER_RT_TEST_COMPILER="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/bin/clang"
			-DCOMPILER_RT_TEST_CXX_COMPILER="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}/bin/clang++"
		)
	fi

	cmake_src_configure
}

src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1

	cmake_build check-builtins
}
