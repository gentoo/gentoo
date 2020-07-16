# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit cmake python-any-r1

DESCRIPTION="CommonMark parsing and rendering library and program in C"
HOMEPAGE="https://github.com/commonmark/cmark"
SRC_URI="https://github.com/commonmark/cmark/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/0.29.0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( ${PYTHON_DEPS} )"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DCMARK_LIB_FUZZER=OFF
		-DCMARK_SHARED=ON
		-DCMARK_STATIC=OFF
		-DCMARK_TESTS="$(usex test)"
	)
	cmake_src_configure
}
