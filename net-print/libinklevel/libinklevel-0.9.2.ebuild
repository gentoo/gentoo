# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools multilib

MY_P="${P/_/}"
DESCRIPTION="A library to get the ink level of your printer"
HOMEPAGE="http://libinklevel.sourceforge.net/"
SRC_URI="mirror://sourceforge/libinklevel/${MY_P}.tar.gz"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
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

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README
	use static-libs || rm "${D}"/usr/$(get_libdir)/libinklevel.{a,la}
}
