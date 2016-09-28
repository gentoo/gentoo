# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="Microsoft Works file word processor format import filter library"
HOMEPAGE="http://libwps.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"

LICENSE="|| ( LGPL-2.1 MPL-2.0 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~x86"
IUSE="doc debug static-libs"

RDEPEND="
	app-text/libwpd:0.10
	dev-libs/boost:=
	dev-libs/librevenge
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_configure() {
	econf \
		--disable-werror \
		$(use_enable static-libs static) \
		--docdir=/usr/share/doc/${PF} \
		$(use_with doc docs) \
		$(use_enable debug)
}

src_install() {
	default
	prune_libtool_files --all
}
