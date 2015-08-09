# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools eutils udev vcs-snapshot

MY_PV="v_${PV//./_}"
DESCRIPTION="library to add support for consumer fingerprint readers"
HOMEPAGE="http://cgit.freedesktop.org/libfprint/libfprint/"
SRC_URI="http://cgit.freedesktop.org/${PN}/${PN}/snapshot/${MY_PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 x86"
IUSE="debug static-libs"

RDEPEND="virtual/libusb:1
	dev-libs/nss
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] x11-libs/gdk-pixbuf )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${P}-automake-1.13.patch"
	epatch "${FILESDIR}/${P}-support-147e_2020.patch"
	eautoreconf
}

src_configure() {
	econf \
		--with-drivers=all \
		$(use_enable debug debug-log) \
		$(use_enable static-libs static) \
		-enable-udev-rules \
		--with-udev-rules-dir=$(get_udevdir)/rules.d
	# --disable-udev-rules fails https://bugs.freedesktop.org/show_bug.cgi?id=59076
	# $(use_enable udev udev-rules) \
}

src_install() {
	emake DESTDIR="${D}" install

	prune_libtool_files

	dodoc AUTHORS HACKING NEWS README THANKS TODO
}
