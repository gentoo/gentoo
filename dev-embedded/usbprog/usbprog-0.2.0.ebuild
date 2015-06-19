# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/usbprog/usbprog-0.2.0.ebuild,v 1.3 2012/05/03 02:35:37 jdhore Exp $

EAPI="4"

DESCRIPTION="flashtool for the multi purpose programming adapter usbprog"
HOMEPAGE="http://www.embedded-projects.net/index.php?page_id=215"
SRC_URI="mirror://berlios/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs X"

RDEPEND="X? ( >=x11-libs/wxGTK-2.6.0 )
	>=dev-libs/libxml2-2.0.0
	net-misc/curl
	virtual/libusb:0
	sys-libs/readline"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf \
		$(use_enable X gui) \
		$(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || find "${ED}" -name '*.la' -delete
}
