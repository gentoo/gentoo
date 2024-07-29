# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="JSON-RPC (1.0 & 2.0) framework for C++"
HOMEPAGE="https://github.com/cinemast/libjson-rpc-cpp/"
SRC_URI="
	https://github.com/cinemast/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0/1"
KEYWORDS="~amd64 ~x86"
IUSE="+http-client +http-server redis-client redis-server +stubgen test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/jsoncpp:=
	http-client? ( net-misc/curl:= )
	http-server? ( net-libs/libmicrohttpd:= )
	redis-client? ( dev-libs/hiredis:= )
	redis-server? ( dev-libs/hiredis:= )
	stubgen? ( dev-libs/argtable:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	test? (
		<dev-cpp/catch-3
	)
"

src_configure() {
	local mycmakeargs=(
		-DHTTP_CLIENT=$(usex http-client)
		-DHTTP_SERVER=$(usex http-server)
		-DREDIS_CLIENT=$(usex redis-client)
		-DREDIS_SERVER=$(usex redis-server)
		# they have no deps
		-DTCP_SOCKET_CLIENT=ON
		-DTCP_SOCKET_SERVER=ON
		-DSERIAL_PORT_CLIENT=ON
		-DSERIAL_PORT_SERVER=ON
		-DUNIX_DOMAIN_SOCKET_CLIENT=ON
		-DUNIX_DOMAIN_SOCKET_SERVER=ON
		# they are not installed
		-DCOMPILE_EXAMPLES=OFF
		-DCOMPILE_STUBGEN=$(usex stubgen)
		-DCOMPILE_TESTS=$(usex test)
		# disable coverage-related flags
		-DWITH_COVERAGE=OFF
	)
	use test && mycmakeargs+=(
		-DCATCH_INCLUDE_DIR="${EPREFIX}/usr/include"
	)

	cmake_src_configure
}

src_test() {
	# Tests fail randomly when run in parallel
	local MAKEOPTS=-j1
	cmake_src_test
}
