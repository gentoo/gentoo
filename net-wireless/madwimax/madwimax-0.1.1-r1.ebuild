# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/madwimax/madwimax-0.1.1-r1.ebuild,v 1.2 2014/08/10 20:34:59 slyfox Exp $

EAPI=5
inherit autotools linux-info udev

DESCRIPTION="A reverse-engineered Linux driver for mobile WiMAX devices based on Samsung CMC-730 chip"
HOMEPAGE="http://code.google.com/p/madwimax/"
SRC_URI="http://madwimax.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc"

RDEPEND="virtual/libusb:1"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? (
		app-text/asciidoc
		app-text/docbook2X
	)"

CONFIG_CHECK="~TUN"

src_prepare() {
	sed -i -e "s:\(for name in docbook2\)x-man:\1man\.pl:" configure.ac || die
	eautoreconf
}

src_configure() {
	local myconf
	use doc || myconf="--without-man-pages"
	econf ${myconf}
}

src_install() {
	emake DESTDIR="${D}" udevrulesdir="$(get_udevdir)"/rules.d install
	mv "${ED}/$(get_udevdir)"/rules.d/{z60_,60-}madwimax.rules || die
	dodoc README
}
