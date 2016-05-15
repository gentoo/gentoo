# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="canonical libwebsockets.org websocket library"
HOMEPAGE="https://libwebsockets.org/"
SRC_URI="https://github.com/warmcat/libwebsockets/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ssl +zlib static-libs +http2 ipv6 +server -client"

RDEPEND="
	ssl?  ( dev-libs/openssl:0 )
	zlib? ( sys-libs/zlib )
	"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
	-DLWS_WITH_STATIC=$(usex static-libs)
	-DLWS_LINK_TESTAPPS_DYNAMIC=$(usex !static-libs)
	-DLWS_WITH_SSL=$(usex ssl)
	-DLWS_WITHOUT_CLIENT=$(usex !client)
	-DLWS_WITHOUT_SERVER=$(usex !server)
	-DLWS_WITH_HTTP2=$(usex http2)
	-DLWS_IPV6=$(usex ipv6)
	)

	cmake-utils_src_configure
}
