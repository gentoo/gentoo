# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="https://github.com/cinemast/${PN}.git"
EGIT_BRANCH=develop
inherit cmake-utils git-r3

DESCRIPTION="JSON-RPC (1.0 & 2.0) framework for C++"
HOMEPAGE="https://github.com/cinemast/libjson-rpc-cpp"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +http-client +http-server +stubgen test"

RDEPEND="
	dev-libs/jsoncpp:=
	http-client? ( net-misc/curl:= )
	http-server? ( net-libs/libmicrohttpd:= )
	stubgen? ( dev-libs/argtable:= )"
DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-cpp/catch )"

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
