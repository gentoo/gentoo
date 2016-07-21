# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools

DESCRIPTION="Library for creating diff files"
HOMEPAGE="http://www.xmailserver.org/xdiff-lib.html"
SRC_URI="http://www.xmailserver.org/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog
}

src_prepare() {
	# test utils require static libs ...
	sed 's/test//g' -i Makefile.am
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	rm "${D}/usr/$(get_libdir)"/*.la
}
