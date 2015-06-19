# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libusbhp/libusbhp-1.0.2.ebuild,v 1.3 2015/02/16 04:10:17 vapier Exp $

EAPI=5

DESCRIPTION="Usb Hotplug Library"
HOMEPAGE="http://www.aasimon.org/libusbhp/"
SRC_URI="http://www.aasimon.org/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~x86"
IUSE="static-libs"

RDEPEND=">=virtual/libudev-147"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--without-debug
}

src_install() {
	default
	use static-libs || find "${ED}" -name '*.la' -delete
}
