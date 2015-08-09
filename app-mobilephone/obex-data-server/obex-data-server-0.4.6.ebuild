# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

DESCRIPTION="A DBus service providing easy to use API for using OBEX"
HOMEPAGE="http://tadas.dailyda.com/blog/category/obex-data-server/"
SRC_URI="http://tadas.dailyda.com/software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ppc ppc64 x86"

IUSE="debug gtk imagemagick usb"

RDEPEND="dev-libs/glib:2
	>=dev-libs/dbus-glib-0.7
	sys-apps/dbus
	>=net-wireless/bluez-4.31
	<dev-libs/openobex-1.7.1
	imagemagick? ( !gtk? ( || ( media-gfx/imagemagick media-gfx/graphicsmagick[imagemagick] ) ) )
	gtk? ( x11-libs/gtk+:2 )
	usb? ( virtual/libusb:0 )
	!app-mobilephone/obexd[server]"

DEPEND="virtual/pkgconfig
	${RDEPEND}"

src_configure() {
	local bip="no"
	use imagemagick && bip="magick"
	use gtk && bip="gdk-pixbuf"
	econf \
		--enable-bip=${bip} \
		$(use_enable usb) \
		--disable-system-config \
		$(use_enable debug) \
		--disable-silent-rules
}
