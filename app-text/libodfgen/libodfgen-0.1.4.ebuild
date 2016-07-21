# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="Library to generate ODF documents from libwpd and libwpg"
HOMEPAGE="http://libwpd.sf.net"
SRC_URI="mirror://sourceforge/libwpd/${P}.tar.xz"

# git://git.code.sf.net/p/libwpd/libodfgen

LICENSE="|| ( LGPL-2.1 MPL-2.0 )"
SLOT="0"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	dev-libs/librevenge
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.46
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"

src_configure() {
	econf \
		--disable-static \
		--disable-werror \
		--with-sharedptr=boost \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		$(use_with doc docs)
}

src_install() {
	default
	prune_libtool_files --all
}
