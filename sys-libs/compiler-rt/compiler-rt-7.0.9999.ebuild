# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils flag-o-matic git-r3 llvm multiprocessing \
	python-any-r1 toolchain-funcs

DESCRIPTION="Compiler runtime library for clang (built-in part)"
HOMEPAGE="https://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="https://git.llvm.org/git/compiler-rt.git
	https://github.com/llvm-mirror/compiler-rt.git"
EGIT_BRANCH="release_70"

LICENSE="|| ( UoI-NCSA MIT )"
# Note: this needs to be updated to match version of clang-9999
SLOT="7.0.0"
KEYWORDS=""
IUSE="+clang test"
RESTRICT="!test? ( test ) !clang? ( test )"

CLANG_SLOT=${SLOT%%.*}
# llvm-6 for new lit options
DEPEND="
	>=sys-devel/llvm-6
	clang? ( sys-devel/clang )
	test? (
		$(python_gen_any_dep "dev-python/lit[\${PYTHON_USEDEP}]")
		=sys-devel/clang-${PV%_*}*:${CLANG_SLOT} )
	${PYTHON_DEPS}"

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

pkg_pretend() {
	if ! use clang && ! tc-is-clang; then
		ewarn "Building using a compiler other than clang may result in broken atomics"
		ewarn "library. Enable USE=clang unless you have a very good reason not to."
	fi
}

pkg_setup() {
	llvm_pkg_setup
	python-any-r1_pkg_setup
}

test_compiler() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} "${@}" -o /dev/null -x c - \
		<<<'int main() { return 0; }' &>/dev/null
}

src_configure() {
	# pre-set since we need to pass it to cmake
	BUILD_DIR=${WORKDIR}/${P}_build

	local nolib_flags=( -nodefaultlibs -lc )
	if use clang; then
		local -x CC=${CHOST}-clang
		local -x CXX=${CHOST}-clang++
		# ensure we can use clang before installing compiler-rt
		local -x LDFLAGS="${LDFLAGS} ${nolib_flags[*]}"
		strip-unsupported-flags
	elif ! test_compiler; then
		if test_compiler "${nolib_flags[@]}"; then
			local -x LDFLAGS="${LDFLAGS} ${nolib_flags[*]}"
			ewarn "${CC} seems to lack runtime, trying with ${nolib_flags[*]}"
		fi
	fi

	local mycmakeargs=(
		-DCOMPILER_RT_INSTALL_PATH="${EPREFIX}/usr/lib/clang/${SLOT}"

		-DCOMPILER_RT_INCLUDE_TESTS=$(usex test)
		-DCOMPILER_RT_BUILD_LIBFUZZER=OFF
		-DCOMPILER_RT_BUILD_PROFILE=OFF
		-DCOMPILER_RT_BUILD_SANITIZERS=OFF
		-DCOMPILER_RT_BUILD_XRAY=OFF
	)

	if use prefix && [[ "${CHOST}" == *-darwin* ]] ; then
		mycmakeargs+=(
			# disable use of SDK for the system itself
			-DDARWIN_macosx_CACHED_SYSROOT=/
		)
	fi

	if use test; then
		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="-vv;-j;${LIT_JOBS:-$(makeopts_jobs "${MAKEOPTS}" "$(get_nproc)")}"

			-DCOMPILER_RT_TEST_COMPILER="${EPREFIX}/usr/lib/llvm/${CLANG_SLOT}/bin/clang"
			-DCOMPILER_RT_TEST_CXX_COMPILER="${EPREFIX}/usr/lib/llvm/${CLANG_SLOT}/bin/clang++"
		)
	fi

	cmake-utils_src_configure
}

src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1

	cmake-utils_src_make check-builtins
}
