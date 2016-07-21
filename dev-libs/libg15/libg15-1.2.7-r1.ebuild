# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="The libg15 library gives low-level access to the Logitech G15 keyboard"
HOMEPAGE="http://g15tools.sourceforge.net/"
SRC_URI="mirror://sourceforge/g15tools/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

DEPEND="=virtual/libusb-0*"
RDEPEND=${DEPEND}

DOCS=( AUTHORS README ChangeLog )

src_configure() {
	econf \
		--disable-static
}

src_install() {
	default

	find "${ED}" -name '*.la' -exec rm -f {} +
}
