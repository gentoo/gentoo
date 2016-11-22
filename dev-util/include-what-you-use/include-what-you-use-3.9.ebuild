# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit cmake-utils flag-o-matic python-single-r1

WEIRD_UPSTREAM_VERSION=0.7

DESCRIPTION="Find unused include directives in C/C++ programs"
HOMEPAGE="http://include-what-you-use.org/"
SRC_URI="http://include-what-you-use.org/downloads/${PN}-${WEIRD_UPSTREAM_VERSION}.src.tar.gz -> ${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="=sys-devel/llvm-${PV}*
	=sys-devel/clang-${PV}*
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

S=${WORKDIR}/llvm/tools/clang/tools/${PN}

src_prepare() {
	python_fix_shebang .
	default
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
