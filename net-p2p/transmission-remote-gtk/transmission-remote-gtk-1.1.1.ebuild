# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit eutils fdo-mime gnome2-utils

DESCRIPTION="GTK+ client for management of the Transmission BitTorrent client, over HTTP RPC"
HOMEPAGE="https://code.google.com/p/transmission-remote-gtk"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="ayatana debug geoip libnotify libproxy"

RESTRICT="test"

RDEPEND=">=dev-libs/glib-2.32
	>=dev-libs/json-glib-0.12.6
	net-misc/curl
	>=x11-libs/gtk+-3.4:3
	ayatana? ( dev-libs/libappindicator:3 )
	geoip? ( dev-libs/geoip )
	libnotify? ( >=x11-libs/libnotify-0.7 )
	libproxy? ( net-libs/libproxy )"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

DOCS="AUTHORS ChangeLog README"

src_configure() {
	econf \
		$(use_enable debug) \
		--enable-gtk3 \
		$(use_with geoip libgeoip) \
		$(use_with libnotify) \
		$(use_with libproxy) \
		$(use_with ayatana libappindicator)
}

pkg_preinst() {	gnome2_icon_savelist; }
pkg_postinst() { fdo-mime_desktop_database_update; gnome2_icon_cache_update; }
pkg_postrm() { fdo-mime_desktop_database_update; gnome2_icon_cache_update; }
