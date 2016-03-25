# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="canonical libwebsockets.org websocket library"
HOMEPAGE="https://libwebsockets.org/"
SRC_URI="https://github.com/warmcat/libwebsockets/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

DEPEND="
	dev-util/cmake
	dev-libs/openssl
	"
RDEPEND=""

src_install() {
	 cmake-utils_src_install
	 use static-libs || rm -f "${D}"/usr/lib*/lib*.a || die
}
