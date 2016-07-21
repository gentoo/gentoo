# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
WX_GTK_VER="3.0"

inherit eutils wxwidgets

DESCRIPTION="flashtool for the multi purpose programming adapter usbprog"
HOMEPAGE="http://www.embedded-projects.net/index.php?page_id=215"
#SRC_URI="mirror://berlios/${PN}/${P}.tar.bz2"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs X"

RDEPEND="
	X? ( x11-libs/wxGTK:${WX_GTK_VER} )
	>=dev-libs/libxml2-2.0.0
	net-misc/curl
	virtual/libusb:0
	sys-libs/readline:0
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-wx3.0.patch
}

src_configure() {
	use X && need-wxwidgets unicode
	econf \
		$(use_enable X gui) \
		$(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || find "${ED}" -name '*.la' -delete
}
