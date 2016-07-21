# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Cross-platform XML-RPC client/server library written in C"
HOMEPAGE="http://oss.zonio.net/libxr.htm"
SRC_URI="http://oss.zonio.net/releases/libxr/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="libressl"
# IUSE="json"

RDEPEND=">=dev-libs/glib-2.12
	 >=dev-libs/libxml2-2.6.20
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )"
#	json? ( >=dev-libs/json-c-0.3 )"
DEPEND="${RDEPEND}
		dev-util/re2c
		virtual/pkgconfig"

src_configure() {
	econf --without-json
}
