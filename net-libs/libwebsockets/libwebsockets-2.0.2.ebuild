# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="canonical libwebsockets.org websocket library"
HOMEPAGE="https://libwebsockets.org/"
SRC_URI="https://github.com/warmcat/libwebsockets/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+http2 +ssl client ipv6 libev libressl libuv static-libs"

RDEPEND="
	sys-libs/zlib
	libev? ( dev-libs/libev )
	libuv? ( dev-libs/libuv )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
"
DEPEND="${RDEPEND}
	dev-lang/perl
"

src_configure() {
	local mycmakeargs=(
		-DLWS_IPV6=$(usex ipv6 ON OFF)
		-DLWS_LINK_TESTAPPS_DYNAMIC=$(usex !static-libs ON OFF)
		-DLWS_WITH_HTTP2=$(usex http2 ON OFF)
		-DLWS_WITH_STATIC=$(usex static-libs ON OFF)
		-DLWS_WITH_LIBEV=$(usex libev ON OFF)
		-DLWS_WITH_LIBUV=$(usex libuv ON OFF)
		-DLWS_WITH_SSL=$(usex ssl ON OFF)
		-DLWS_WITHOUT_CLIENT=$(usex !client ON OFF)
		-DLWS_WITHOUT_TEST_CLIENT=$(usex !client ON OFF)
		-DCMAKE_DISABLE_FIND_PACKAGE_Git=ON
	)

	cmake-utils_src_configure
}
