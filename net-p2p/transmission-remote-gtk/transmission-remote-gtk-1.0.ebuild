# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/transmission-remote-gtk/transmission-remote-gtk-1.0.ebuild,v 1.7 2012/05/04 06:33:35 jdhore Exp $

EAPI=4
inherit gnome2-utils

DESCRIPTION="GTK client for management of the Transmission BitTorrent client, over HTTP RPC"
HOMEPAGE="http://code.google.com/p/transmission-remote-gtk"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug geoip libproxy unique"
RESTRICT="test"

RDEPEND=">=dev-libs/glib-2.22:2
	>=dev-libs/json-glib-0.12.2
	unique? ( dev-libs/libunique:1 )
	libproxy? ( net-libs/libproxy )
	net-misc/curl
	>=x11-libs/gtk+-2.16:2
	x11-libs/libnotify
	geoip? ( dev-libs/geoip )"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

DOCS=( AUTHORS README )

src_configure() {
	# disable gtk3 for now because upstream doesn't consider it "ready".
	# Also disable libappindicator till gtk3 is ready since ayatana on
	# gtk2 is deprecated in Gentoo.
	econf \
		$(use_enable debug) \
		$(use_with geoip libgeoip) \
		$(use_with libproxy) \
		$(use_with unique libunique) \
		--without-libappindicator \
		--disable-gtk3
}

pkg_preinst() {	gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
