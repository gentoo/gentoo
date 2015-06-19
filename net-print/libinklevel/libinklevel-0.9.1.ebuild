# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-print/libinklevel/libinklevel-0.9.1.ebuild,v 1.1 2015/03/13 23:03:15 mrueg Exp $

EAPI=5

inherit autotools eutils multilib

MY_P="${P/_/}"
DESCRIPTION="A library to get the ink level of your printer"
HOMEPAGE="http://libinklevel.sourceforge.net/"
SRC_URI="mirror://sourceforge/libinklevel/${MY_P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="GPL-2"
IUSE="debug static-libs"

DEPEND=">=sys-libs/libieee1284-0.2.11
	virtual/libusb:1"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i -e "/^dist_doc_DATA/d" Makefile.am \
		|| die "Failed to disable installation of docs"
	eautoreconf
}

src_configure() {
	econf $(use_enable debug)
}

src_install () {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README
	use static-libs || rm "${D}"/usr/$(get_libdir)/libinklevel.{a,la}
}
