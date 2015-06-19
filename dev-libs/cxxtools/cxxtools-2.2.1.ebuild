# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cxxtools/cxxtools-2.2.1.ebuild,v 1.2 2014/01/23 21:24:45 hd_brummy Exp $

EAPI=5

DESCRIPTION="Collection of general purpose C++-classes"
HOMEPAGE="http://www.tntnet.org/cxxtools.hms"
SRC_URI="http://www.tntnet.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"
IUSE=""

RDEPEND="virtual/libiconv"
DEPEND="${RDEPEND}"

src_configure() {
	econf \
		--disable-dependency-tracking \
		--disable-demos \
		--disable-unittest
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog
}
