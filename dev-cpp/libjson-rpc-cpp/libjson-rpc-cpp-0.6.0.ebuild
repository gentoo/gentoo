# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="JSON-RPC (1.0 & 2.0) framework for C++"
HOMEPAGE="https://github.com/cinemast/libjson-rpc-cpp"
SRC_URI="https://github.com/cinemast/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc +http-client +http-server +stubgen test"

RDEPEND="
	dev-libs/jsoncpp:=
	http-client? ( net-misc/curl:= )
	http-server? ( net-libs/libmicrohttpd:= )
	stubgen? ( dev-libs/argtable:= )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-cpp/catch )"

src_prepare() {
	default

	# https://github.com/cinemast/libjson-rpc-cpp/pull/161
	sed -i -e '/DESTINATION/s:lib:lib${LIB_SUFFIX}:' \
		src/jsonrpccpp/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DHTTP_CLIENT=$(usex http-client)
		-DHTTP_SERVER=$(usex http-server)
		# they are not installed but required for tests to build
		-DCOMPILE_EXAMPLES=$(usex test)
		-DCOMPILE_STUBGEN=$(usex stubgen)
		-DCOMPILE_TESTS=$(usex test)
		-DCATCH_INCLUDE_DIR="${EPREFIX}/usr/include/catch"
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	use doc && emake -C "${BUILD_DIR}" doc
}

src_install() {
	cmake-utils_src_install

	use doc && dodoc -r "${BUILD_DIR}"/doc/html
}
