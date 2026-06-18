# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )

inherit cmake python-any-r1

DESCRIPTION="GitHub's fork of cmark"
HOMEPAGE="https://github.com/github/cmark-gfm"

MY_PV="$(ver_rs 3 '.gfm.')"
SRC_URI="https://github.com/github/cmark-gfm/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="BSD-2"
SLOT="0/${MY_PV}"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="test? ( ${PYTHON_DEPS} )"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}"/cmark-gfm-0.29.0.gfm.13-cmake4.patch
)

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DCMARK_LIB_FUZZER=OFF
		-DCMARK_SHARED=ON
		-DCMARK_STATIC=OFF
		-DCMARK_TESTS=$(usex test)
	)
	if use test; then
		# Force running all tests, avoid warning when option is unused
		mycmakeargs+=( -DSPEC_TESTS=ON )
	fi
	cmake_src_configure
}
