# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils udev vcs-snapshot

MY_PV="V_${PV//./_}"
DESCRIPTION="library to add support for consumer fingerprint readers"
HOMEPAGE="http://cgit.freedesktop.org/libfprint/libfprint/"
SRC_URI="http://cgit.freedesktop.org/${PN}/${PN}/snapshot/${MY_PV}.tar.bz2 -> ${P}.tar.bz2
	http://dev.gentoo.org/~xmw/${P}_vfs0050.patch.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug static-libs vanilla"

RDEPEND="virtual/libusb:1
	dev-libs/glib:2
	dev-libs/nss
	x11-libs/pixman"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	if ! use vanilla ; then
		epatch "${WORKDIR}"/${P}_vfs0050.patch
	fi

	# upeke2 and fdu2000 were missing from all_drivers.
	sed -e '/^all_drivers=/s:"$: upeke2 fdu2000":' \
		-i configure.ac || die

	eautoreconf
}

src_configure() {
	econf \
		--with-drivers=all \
		$(use_enable debug debug-log) \
		$(use_enable static-libs static) \
		-enable-udev-rules \
		--with-udev-rules-dir=$(get_udevdir)/rules.d
}

src_install() {
	default

	prune_libtool_files

	dodoc AUTHORS HACKING NEWS README THANKS TODO
}
