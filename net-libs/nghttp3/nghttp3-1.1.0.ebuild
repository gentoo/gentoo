# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ngtcp2/nghttp3.git"
	inherit git-r3
else
	SRC_URI="https://github.com/ngtcp2/nghttp3/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm64 ~hppa"
fi

DESCRIPTION="HTTP/3 library written in C"
HOMEPAGE="https://github.com/ngtcp2/nghttp3/"

LICENSE="MIT"
SLOT="0/0"
IUSE="static-libs test"

BDEPEND="virtual/pkgconfig"
DEPEND="test? ( >=dev-util/cunit-2.1[${MULTILIB_USEDEP}] )"
RDEPEND=""
RESTRICT="!test? ( test )"

multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_LIB_ONLY=ON
		-DENABLE_STATIC_LIB=$(usex static-libs)
		-DENABLE_EXAMPLES=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_CUnit=$(usex !test)
	)
	cmake_src_configure
}

multilib_src_test() {
	cmake_build check
}
