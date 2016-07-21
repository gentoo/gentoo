# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit autotools

DESCRIPTION="general-purpose stream-handling tool like UNIX dd"
HOMEPAGE="http://www.cons.org/cracauer/cstream.html"
SRC_URI="http://www.cons.org/cracauer/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
