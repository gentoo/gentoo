# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Collection of general purpose C++-classes"
HOMEPAGE="http://www.tntnet.org/cxxtools.html"
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
