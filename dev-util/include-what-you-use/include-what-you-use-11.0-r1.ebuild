# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake flag-o-matic llvm python-single-r1

# Sometimes the tag is clang_9, sometimes it's IWYU-0.13
UPSTREAM_PV=0.15

DESCRIPTION="Find unused include directives in C/C++ programs"
HOMEPAGE="https://include-what-you-use.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${UPSTREAM_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

LLVM_MAX_SLOT=11

RDEPEND="
	sys-devel/clang:${LLVM_MAX_SLOT}=
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

S=${WORKDIR}/${PN}-${UPSTREAM_PV}

llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

pkg_setup() {
	llvm_pkg_setup
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
		-DCMAKE_INSTALL_PREFIX="$(get_llvm_prefix "${LLVM_MAX_SLOT}")"
	)
	cmake_src_configure
}

src_test() {
	"${EPYTHON}" run_iwyu_tests.py
}
