# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit cmake-utils flag-o-matic python-single-r1

DESCRIPTION="Find unused include directives in C/C++ programs"
HOMEPAGE="https://include-what-you-use.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/clang_${PV}.tar.gz -> ${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="=sys-devel/llvm-${PV}*
	=sys-devel/clang-${PV}*
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

S=${WORKDIR}/${PN}-clang_${PV}

src_prepare() {
	cmake-utils_src_prepare
	python_fix_shebang .
}

src_configure() {
	local mycmakeargs=(
		-DIWYU_LLVM_INCLUDE_PATH=$(llvm-config --includedir)
		-DIWYU_LLVM_LIB_PATH=$(llvm-config --libdir)
	)
	cmake-utils_src_configure
}

src_test() {
	"${EPYTHON}" run_iwyu_tests.py
}
