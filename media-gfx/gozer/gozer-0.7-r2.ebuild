# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit autotools

DESCRIPTION="tool for rendering arbitrary text as graphics, using ttfs and styles"
HOMEPAGE="http://www.linuxbrit.co.uk/gozer/"
SRC_URI="http://www.linuxbrit.co.uk/downloads/${P}.tar.gz"

LICENSE="feh LGPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="x11-libs/libXext
	>=media-libs/giblib-1.2.1"
RDEPEND=">=media-libs/giblib-1.2.1
	media-libs/imlib2"

src_prepare() {
	sed -i src/Makefile.am \
		-e 's|-g -O3|$(CFLAGS)|g' \
		-e '/LDFLAGS/s|=|+=|g' \
		|| die "sed src/Makefile.am"
	eautoreconf
}

src_install() {
	emake install DESTDIR="${D}" || die
	rm -rf "${D}"/usr/doc
	dodoc TODO README AUTHORS ChangeLog
}
