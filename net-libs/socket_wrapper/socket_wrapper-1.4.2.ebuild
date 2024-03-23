# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic

DESCRIPTION="Library passing all socket communications through unix sockets"
HOMEPAGE="https://cwrap.org/socket_wrapper.html"
SRC_URI="https://ftp.samba.org/pub/cwrap/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( >=dev-util/cmocka-1.1.0 )"

src_configure() {
	# https://gcc.gnu.org/PR46596
	# https://gcc.gnu.org/PR101270
	filter-flags -fno-semantic-interposition

	local mycmakeargs=(
		-DUNIT_TESTING=$(usex test ON OFF)
	)
	cmake-multilib_src_configure
}

src_test() {
	ewarn "test_echo_tcp_poll takes a while to run!"
	cmake_src_test
}
