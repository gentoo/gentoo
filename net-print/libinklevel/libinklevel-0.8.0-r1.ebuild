# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/libinklevel/libinklevel-0.8.0-r1.ebuild,v 1.5 2012/05/21 19:19:29 xarthisius Exp $

EAPI="2"

inherit autotools eutils

MY_P="${P/_/}"
DESCRIPTION="A library to get the ink level of your printer"
HOMEPAGE="http://libinklevel.sourceforge.net/"
SRC_URI="mirror://sourceforge/libinklevel/${MY_P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
LICENSE="GPL-2"
IUSE="debug"

DEPEND=">=sys-libs/libieee1284-0.2.11"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-automagicdebug.patch
	sed -i -e "/^dist_doc_DATA/d" Makefile.am \
		|| die "Failed to disable installation of docs"
	eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"
	rm "${D}"/usr/lib/libinklevel.la
}
