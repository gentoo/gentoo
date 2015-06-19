# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/ario/ario-1.5.1.ebuild,v 1.8 2014/03/22 12:15:59 angelos Exp $

EAPI=5
GNOME2_LA_PUNT=yes
PYTHON_DEPEND="python? 2"

inherit gnome2 python

DESCRIPTION="a GTK2 MPD (Music Player Daemon) client inspired by Rythmbox"
HOMEPAGE="http://ario-player.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}-player/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="audioscrobbler dbus debug +idle libnotify nls python taglib zeroconf"

RDEPEND=">=dev-libs/glib-2.14:2
	dev-libs/libgcrypt:0=
	dev-libs/libunique:1
	dev-libs/libxml2:2
	media-libs/libmpdclient
	net-misc/curl
	net-libs/gnutls
	>=x11-libs/gtk+-2.16:2
	audioscrobbler? ( net-libs/libsoup:2.4 )
	dbus? ( dev-libs/dbus-glib )
	libnotify? ( x11-libs/libnotify )
	python? ( dev-python/pygtk:2
		dev-python/pygobject:2 )
	taglib? ( media-libs/taglib )
	zeroconf? ( net-dns/avahi )"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	sys-devel/gettext"

DOCS=( AUTHORS )

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-single-includes.patch
}

src_configure() {
	econf \
		--disable-static \
		--disable-xmms2 \
		--enable-libmpdclient2 \
		--enable-search \
		--enable-playlists \
		--disable-deprecations \
		$(use_enable audioscrobbler) \
		$(use_enable dbus) \
		$(use_enable debug) \
		$(use_enable idle mpdidle) \
		$(use_enable libnotify notify) \
		$(use_enable nls) \
		$(use_enable python) \
		$(use_enable taglib) \
		$(use_enable zeroconf avahi)
}
