# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit cmake llvm llvm.org python-single-r1

DESCRIPTION="The LLVM debugger"
HOMEPAGE="https://llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="0/${LLVM_SOABI}"
KEYWORDS=""
IUSE="debug +libedit lzma ncurses +python test +xml"
RESTRICT="test"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

DEPEND="
	libedit? ( dev-libs/libedit:0= )
	lzma? ( app-arch/xz-utils:= )
	ncurses? ( >=sys-libs/ncurses-5.9-r3:0= )
	xml? ( dev-libs/libxml2:= )
	~sys-devel/clang-${PV}
	~sys-devel/llvm-${PV}
"
RDEPEND="
	${DEPEND}
	python? (
		$(python_gen_cond_dep '
			dev-python/six[${PYTHON_USEDEP}]
		')
		${PYTHON_DEPS}
	)
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/cmake-3.16
	python? (
		>=dev-lang/swig-3.0.11
		$(python_gen_cond_dep '
			dev-python/six[${PYTHON_USEDEP}]
		')
	)
	test? (
		$(python_gen_cond_dep "
			~dev-python/lit-${PV}[\${PYTHON_USEDEP}]
			dev-python/psutil[\${PYTHON_USEDEP}]
		")
		sys-devel/lld
	)
"

LLVM_COMPONENTS=( lldb cmake )
LLVM_TEST_COMPONENTS=( llvm/lib/Testing/Support llvm/utils/unittest )
llvm.org_set_globals

pkg_setup() {
	LLVM_MAX_SLOT=${LLVM_MAJOR} llvm_pkg_setup
	python-single-r1_pkg_setup
}

src_configure() {
	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	local mycmakeargs=(
		-DLLDB_ENABLE_CURSES=$(usex ncurses)
		-DLLDB_ENABLE_LIBEDIT=$(usex libedit)
		-DLLDB_ENABLE_PYTHON=$(usex python)
		-DLLDB_ENABLE_LZMA=$(usex lzma)
		-DLLDB_ENABLE_LIBXML2=$(usex xml)
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

		-DLLDB_EXTERNAL_CLANG_RESOURCE_DIR="${BROOT}/usr/lib/clang/${LLVM_VERSION}"

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
	cmake_build check-lldb-{shell,unit}
	# failures + hangs
	#use python && cmake_build check-lldb-api
}

src_install() {
	cmake_src_install
	find "${D}" -name '*.a' -delete || die

	use python && python_optimize
}
