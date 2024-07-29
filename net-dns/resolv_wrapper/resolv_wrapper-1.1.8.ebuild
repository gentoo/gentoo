# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib

DESCRIPTION="Wrapper for DNS name resolving or DNS faking"
HOMEPAGE="https://cwrap.org/resolv_wrapper.html"
SRC_URI="https://ftp.samba.org/pub/cwrap/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ~ia64 ppc ppc64 sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		dev-util/cmocka
		net-libs/socket_wrapper
	)
"

PATCHES=(
	"${FILESDIR}"/${P}-cmocka-cmake.patch
)

# Work around a problem with >=dev-build/cmake-3.3.0 (bug #558340)
# Because of this we cannot use cmake-multilib_src_configure() here.
multilib_src_configure() {
	local mycmakeargs=(
		-DCMAKE_LIBRARY_PATH=/usr/$(get_libdir)
		-DUNIT_TESTING=$(usex test)
	)
	cmake_src_configure
}
