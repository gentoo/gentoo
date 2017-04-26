# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils flag-o-matic git-r3 llvm python-any-r1 toolchain-funcs

DESCRIPTION="Compiler runtime library for clang (built-in part)"
HOMEPAGE="http://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="http://llvm.org/git/compiler-rt.git
	https://github.com/llvm-mirror/compiler-rt.git"

LICENSE="|| ( UoI-NCSA MIT )"
# Note: this needs to be updated to match version of clang-9999
SLOT="5.0.0"
KEYWORDS=""
IUSE="+clang test"

LLVM_SLOT=${SLOT%%.*}
# llvm-4 needed for --cmakedir
DEPEND="
	>=sys-devel/llvm-4
	clang? ( sys-devel/clang )
	test? (
		$(python_gen_any_dep "~dev-python/lit-${PV}[\${PYTHON_USEDEP}]")
		=sys-devel/clang-${PV%_*}*:${LLVM_SLOT} )
	${PYTHON_DEPS}"

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

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

	if use clang; then
		local -x CC=${CHOST}-clang
		local -x CXX=${CHOST}-clang++
		# ensure we can use clang before installing compiler-rt
		local -x LDFLAGS="${LDFLAGS} -nodefaultlibs -lc"
		strip-unsupported-flags
	elif ! test_compiler; then
		local extra_flags=( -nodefaultlibs -lc )
		if test_compiler "${extra_flags[@]}"; then
			local -x LDFLAGS="${LDFLAGS} ${extra_flags[*]}"
			ewarn "${CC} seems to lack runtime, trying with ${extra_flags[*]}"
		fi
	fi

	local mycmakeargs=(
		-DCOMPILER_RT_INSTALL_PATH="${EPREFIX}/usr/lib/clang/${SLOT}"

		-DCOMPILER_RT_INCLUDE_TESTS=$(usex test)
		-DCOMPILER_RT_BUILD_SANITIZERS=OFF
		-DCOMPILER_RT_BUILD_XRAY=OFF
	)

	if use test; then
		mycmakeargs+=(
			-DLIT_COMMAND="${EPREFIX}/usr/bin/lit"

			-DCOMPILER_RT_TEST_COMPILER="${EPREFIX}/usr/lib/llvm/${LLVM_SLOT}/bin/clang"
			-DCOMPILER_RT_TEST_CXX_COMPILER="${EPREFIX}/usr/lib/llvm/${LLVM_SLOT}/bin/clang++"
		)
	fi

	cmake-utils_src_configure
}

src_test() {
	# respect TMPDIR!
	local -x LIT_PRESERVES_TMP=1

	cmake-utils_src_make check-builtins
}
