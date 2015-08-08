# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
