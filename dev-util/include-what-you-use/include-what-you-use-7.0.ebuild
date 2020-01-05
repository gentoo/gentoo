# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit cmake-utils flag-o-matic llvm python-single-r1

DESCRIPTION="Find unused include directives in C/C++ programs"
HOMEPAGE="https://include-what-you-use.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/clang_${PV}.tar.gz -> ${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

LLVM_MAX_SLOT=7

RDEPEND="sys-devel/llvm:${LLVM_MAX_SLOT}
	sys-devel/clang:${LLVM_MAX_SLOT}
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

S=${WORKDIR}/${PN}-clang_${PV}

pkg_setup() {
	llvm_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	cmake-utils_src_prepare
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
		-DCMAKE_INSTALL_PREFIX="$(get_llvm_prefix "${LLVM_MAX_SLOT}")"
	)
	cmake-utils_src_configure
}

src_test() {
	"${EPYTHON}" run_iwyu_tests.py
}
