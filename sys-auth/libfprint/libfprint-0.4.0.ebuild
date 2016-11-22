# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools eutils udev

MY_PV="v_${PV//./_}"
DESCRIPTION="library to add support for consumer fingerprint readers"
HOMEPAGE="https://cgit.freedesktop.org/libfprint/libfprint/"
SRC_URI="https://cgit.freedesktop.org/${PN}/${PN}/snapshot/${MY_PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86"
IUSE="debug static-libs"

RDEPEND="virtual/libusb:1
	dev-libs/nss
	|| ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] x11-libs/gdk-pixbuf )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_PV}

src_prepare() {
	mkdir m4 || die
	eautoreconf
}

pkg_setup() {
	einfo
	elog "This version does not support fdu2000 and upektc (yet)."
	einfo
}

src_configure() {
	econf \
		$(use_enable debug debug-log) \
		$(use_enable static-libs static)
}

src_install() {
	emake \
		DESTDIR="${D}" \
		udev_rulesdir="$(get_udevdir)/rules.d" \
		install

	prune_libtool_files
	dodoc AUTHORS HACKING NEWS README THANKS TODO
}
