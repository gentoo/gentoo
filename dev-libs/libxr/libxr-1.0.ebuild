# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libxr/libxr-1.0.ebuild,v 1.2 2012/05/04 18:35:46 jdhore Exp $

DESCRIPTION="Cross-platform XML-RPC client/server library written in C"
HOMEPAGE="http://oss.zonio.net/libxr.htm"
SRC_URI="http://oss.zonio.net/releases/libxr/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""
# IUSE="json"

RDEPEND=">=dev-libs/glib-2.12
		 >=dev-libs/libxml2-2.6.20
		 dev-libs/openssl"
#		 json? ( >=dev-libs/json-c-0.3 )"
DEPEND="${RDEPEND}
		virtual/pkgconfig
		dev-util/re2c"

src_compile() {
	econf --without-json || die
	emake || die
}

src_install() {
	emake DESTDIR="$D" install || die
}
