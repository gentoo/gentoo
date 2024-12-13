# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
LLVM_COMPAT=( 19 )

inherit cmake llvm-r1 python-single-r1

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
	llvm-r1_pkg_setup
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

src_test() {
	"${EPYTHON}" run_iwyu_tests.py \
				 -- "${BUILD_DIR}"/bin/${PN} \
		|| die "Tests failed with $? (using ${EPYTHON})"
}
