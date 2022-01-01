# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit cmake llvm llvm.org python-single-r1 toolchain-funcs

DESCRIPTION="The LLVM debugger"
HOMEPAGE="https://llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86"
IUSE="libedit lzma ncurses +python test"
REQUIRED_USE=${PYTHON_REQUIRED_USE}
RESTRICT="test"

RDEPEND="
	libedit? ( dev-libs/libedit:0= )
	lzma? ( app-arch/xz-utils:= )
	ncurses? ( >=sys-libs/ncurses-5.9-r3:0= )
	python? (
		$(python_gen_cond_dep '
			dev-python/six[${PYTHON_USEDEP}]
		')
		${PYTHON_DEPS}
	)
	~sys-devel/clang-${PV}[xml]
	~sys-devel/llvm-${PV}
	!<sys-devel/llvm-4.0"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/cmake-3.16
	python? ( >=dev-lang/swig-3.0.11 )
	test? (
		$(python_gen_cond_dep "
			~dev-python/lit-${PV}[\${PYTHON_USEDEP}]
			dev-python/psutil[\${PYTHON_USEDEP}]
		")
		sys-devel/lld
	)
	${PYTHON_DEPS}"

LLVM_COMPONENTS=( lldb )
LLVM_TEST_COMPONENTS=( llvm/lib/Testing/Support llvm/utils/unittest )
llvm.org_set_globals

pkg_setup() {
	LLVM_MAX_SLOT=${PV%%.*} llvm_pkg_setup
	python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DLLDB_ENABLE_CURSES=$(usex ncurses)
		-DLLDB_ENABLE_LIBEDIT=$(usex libedit)
		-DLLDB_ENABLE_PYTHON=$(usex python)
		-DLLDB_ENABLE_LZMA=$(usex lzma)
		-DLLDB_USE_SYSTEM_SIX=1
		-DLLVM_ENABLE_TERMINFO=$(usex ncurses)

		-DLLDB_INCLUDE_TESTS=$(usex test)

		-DCLANG_LINK_CLANG_DYLIB=ON
		# TODO: fix upstream to detect this properly
		-DHAVE_LIBDL=ON
		-DHAVE_LIBPTHREAD=ON

		# normally we'd have to set LLVM_ENABLE_TERMINFO, HAVE_TERMINFO
		# and TERMINFO_LIBS... so just force FindCurses.cmake to use
		# ncurses with complete library set (including autodetection
		# of -ltinfo)
		-DCURSES_NEED_NCURSES=ON

		-DPython3_EXECUTABLE="${PYTHON}"
	)
	use test && mycmakeargs+=(
		-DLLVM_BUILD_TESTS=$(usex test)
		-DLLVM_MAIN_SRC_DIR="${WORKDIR}/llvm"
		-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
		-DLLVM_LIT_ARGS="$(get_lit_flags)"
	)

	cmake_src_configure
}

src_test() {
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-lldb-lit
	# failures + hangs
	#use python && cmake_build check-lldb
}

src_install() {
	cmake_src_install
	find "${D}" -name '*.a' -delete || die

	use python && python_optimize
}
