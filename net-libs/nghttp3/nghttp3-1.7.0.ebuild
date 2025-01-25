# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ngtcp2/nghttp3.git"
	inherit git-r3
else
	SRC_URI="https://github.com/ngtcp2/nghttp3/releases/download/v${PV}/${P}.tar.xz"
	KEYWORDS="amd64 arm arm64 hppa ~loong ~m68k ~mips ppc64 ~riscv sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
fi

DESCRIPTION="HTTP/3 library written in C"
HOMEPAGE="https://github.com/ngtcp2/nghttp3/"

LICENSE="MIT"
SLOT="0/0"
IUSE="static-libs test"
RESTRICT="!test? ( test )"
# Without static-libs, src_test just won't run any tests and "pass".
REQUIRED_USE="
	test? ( static-libs )
"

BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.7.0-munit-c23.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_LIB_ONLY=ON
		-DENABLE_STATIC_LIB=$(usex static-libs)
		-DENABLE_EXAMPLES=OFF
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}

multilib_src_test() {
	cmake_build check
}
