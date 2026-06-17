# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="$(ver_rs 3 '.gfm.')"
PYTHON_COMPAT=( python3_{12..15} )

inherit cmake python-any-r1

DESCRIPTION="GitHub's fork of cmark"
HOMEPAGE="https://github.com/github/cmark-gfm"
SRC_URI="https://github.com/github/cmark-gfm/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="BSD-2"
SLOT="0/${MY_PV}"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="test? ( ${PYTHON_DEPS} )"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/${PN}-cmake.patch
)

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
