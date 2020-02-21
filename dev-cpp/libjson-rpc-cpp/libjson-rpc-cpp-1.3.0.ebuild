# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="JSON-RPC (1.0 & 2.0) framework for C++"
HOMEPAGE="https://github.com/cinemast/libjson-rpc-cpp"
SRC_URI="https://github.com/cinemast/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/1"
KEYWORDS="~amd64 ~x86"
IUSE="doc +http-client +http-server redis-client redis-server +stubgen test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/jsoncpp:=
	http-client? ( net-misc/curl:= )
	http-server? ( net-libs/libmicrohttpd:= )
	redis-client? ( dev-libs/hiredis:= )
	redis-server? ( dev-libs/hiredis:= )
	stubgen? ( dev-libs/argtable:= )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-cpp/catch:0 )"

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
		-DCATCH_INCLUDE_DIR="${EPREFIX}/usr/include/catch2"
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	use doc && emake -C "${BUILD_DIR}" doc
}

src_test() {
	# Tests fail randomly when run in parallel
	local MAKEOPTS=-j1
	cmake_src_test
}

src_install() {
	cmake_src_install

	use doc && dodoc -r "${BUILD_DIR}"/doc/html
}
