# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Microsoft Works file word processor format import filter library"
HOMEPAGE="https://sourceforge.net/p/libwps/wiki/Home/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="|| ( LGPL-2.1 MPL-2.0 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~x86"
IUSE="doc debug static-libs tools"

RDEPEND="
	dev-libs/librevenge
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_configure() {
	econf \
		--disable-werror \
		--with-sharedptr=c++11 \
		$(use_enable debug) \
		$(use_with doc docs) \
		$(use_enable static-libs static) \
		$(use_enable tools)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
