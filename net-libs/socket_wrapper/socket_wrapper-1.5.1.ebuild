# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib flag-o-matic

DESCRIPTION="Library passing all socket communications through unix sockets"
HOMEPAGE="https://cwrap.org/socket_wrapper.html"
SRC_URI="https://ftp.samba.org/pub/cwrap/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="test? ( >=dev-util/cmocka-1.1.0 )"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.0-stdint.patch
)

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
	CMAKE_SKIP_TESTS=(
		# These fail because no privileges to set priority to avoid
		# deadlock
		test_tcp_listen
		test_echo_tcp_connect
		test_echo_tcp_socket_options
		test_echo_tcp_sendmsg_recvmsg
		test_echo_tcp_sendmmsg_recvmmsg
		test_echo_tcp_write_read
		test_echo_tcp_writev_readv
		test_echo_tcp_get_peer_sock_name
		test_echo_udp_sendto_recvfrom
		test_echo_udp_send_recv
		test_echo_udp_sendmsg_recvmsg
		test_thread_echo_tcp_connect
		test_thread_echo_tcp_write_read
		test_thread_echo_tcp_sendmsg_recvmsg
		test_thread_echo_udp_send_recv
	)

	ewarn "test_echo_tcp_poll takes a while to run!"
	cmake-multilib_src_test
}
