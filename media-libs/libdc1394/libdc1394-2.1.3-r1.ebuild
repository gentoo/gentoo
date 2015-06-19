# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdc1394/libdc1394-2.1.3-r1.ebuild,v 1.9 2012/05/05 08:02:42 jdhore Exp $

EAPI=4
inherit autotools eutils

DESCRIPTION="Library to interface with IEEE 1394 cameras following the IIDC specification"
HOMEPAGE="http://sourceforge.net/projects/libdc1394/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE="doc static-libs X"

RDEPEND=">=sys-libs/libraw1394-1.2.0
	virtual/libusb:1
	X? ( x11-libs/libSM x11-libs/libXv )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-videodev.h.patch \
		"${FILESDIR}"/${PN}-usbinit.patch

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--program-suffix=2 \
		$(use_with X x) \
		$(use_enable doc doxygen-html)
}

src_compile() {
	default
	use doc && emake doc
}

src_install() {
	default
	use doc && dohtml doc/html/*
	find "${ED}" -name '*.la' -exec rm -f {} +
}
