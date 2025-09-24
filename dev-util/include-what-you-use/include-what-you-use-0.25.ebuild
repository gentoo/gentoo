# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
LLVM_COMPAT=( 21 )

inherit cmake llvm-r2 python-single-r1 toolchain-funcs

DESCRIPTION="Find unused include directives in C/C++ programs"
HOMEPAGE="https://include-what-you-use.org/"
SRC_URI="
	https://github.com/${PN}/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}=
		llvm-core/llvm:${LLVM_SLOT}=
	')
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

pkg_setup() {
	llvm-r2_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	python_fix_shebang .
}

src_configure() {
	local mycmakeargs=(
		# Note [llvm install path]
		# Unfortunately all binaries using clang driver
		# have to reside at the same path depth as
		# 'clang' binary itself. See bug #625972
		# Thus as a hack we install it to the same directory
		# as llvm/clang itself.
		-DCMAKE_INSTALL_PREFIX="$(get_llvm_prefix)"
		# Relative path to the clang library
		# https://github.com/include-what-you-use/include-what-you-use/commit/e046d23571876e72719ef96a36ff0cb1cb2e64b6
		-DIWYU_RESOURCE_DIR="../../../clang/${LLVM_SLOT}"
	)
	cmake_src_configure
}

# tc-cpp-is-true and tc-get-cxx-stdlib smashed together
tc-cxx-is-true() {
	local CONDITION=${1}

	$(tc-getCXX)  ${CPPFLAGS} ${CXXFLAGS} -x c++ -E -P - <<-EOF >/dev/null 2>&1
	#if __cplusplus >= 202002L
	#include <version>
	#else
	#include <ciso646>
	#endif
	#if ${CONDITION}
	true
	#else
	#error false
	#endif
	EOF
}

src_test() {
	local -a CMAKE_SKIP_TESTS=()

	if tc-cxx-is-true "defined(_GLIBCXX_RELEASE) && (_GLIBCXX_RELEASE >= 15)"; then
		CMAKE_SKIP_TESTS+=(
			cxx.test_precomputed_tpl_args
			cxx.test_precomputed_tpl_args_cpp14
		)
	fi

	# There could be failures with older libcxx versions as well.
	if tc-cxx-is-true "defined(_LIBCPP_VERSION) && (_LIBCPP_VERSION >= 210101)"; then
		CMAKE_SKIP_TESTS+=(
			cxx.test_badinc
			cxx.test_expl_inst_macro
			cxx.test_iterator
			cxx.test_libbuiltins
			cxx.test_no_char_traits
			cxx.test_overloaded_class
			cxx.test_placement_new
			cxx.test_precomputed_tpl_args
			cxx.test_precomputed_tpl_args_cpp14
			cxx.test_stl_container_provides_allocator
		)
	fi

	cmake_src_test
}
