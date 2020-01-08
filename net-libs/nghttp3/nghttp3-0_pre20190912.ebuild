# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ngtcp2/nghttp3.git"
	inherit autotools git-r3
else
	GIT_COMMIT="51379a041174ad953dc6ad437712f3b279f81919"
	SRC_URI="https://github.com/ngtcp2/nghttp3/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${GIT_COMMIT}"
	KEYWORDS="~amd64 ~hppa"
fi

DESCRIPTION="HTTP/3 library written in C"
HOMEPAGE="https://github.com/ngtcp2/nghttp3/"

LICENSE="MIT"
SLOT="0/0"
IUSE="test"

BDEPEND="virtual/pkgconfig"
DEPEND="test? ( >=dev-util/cunit-2.1[${MULTILIB_USEDEP}] )"
RDEPEND=""
RESTRICT="!test? ( test )"

multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_LIB_ONLY=ON
		-DENABLE_EXAMPLES=OFF
		-DCMAKE_DISABLE_FIND_PACKAGE_CUnit=$(usex !test)
	)
	cmake_src_configure
}

multilib_src_test() {
	cmake_build check
}
