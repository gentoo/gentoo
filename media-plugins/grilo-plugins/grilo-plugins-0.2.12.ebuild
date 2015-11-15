# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no" # --enable-debug only changes CFLAGS
GNOME2_LA_PUNT="yes"

inherit gnome2

DESCRIPTION="A framework for easy media discovery and browsing"
HOMEPAGE="https://wiki.gnome.org/Projects/Grilo"

LICENSE="LGPL-2.1+"
SLOT="0.2"
KEYWORDS="~arm ~ia64"
IUSE="daap +dvd flickr freebox gnome-online-accounts lua pocket tracker upnp-av +vimeo +youtube"

RDEPEND="
	>=dev-libs/glib-2.34:2
	>=media-libs/grilo-0.2.10:${SLOT}[network,playlist]
	>=media-libs/libmediaart-0.1:1.0

	dev-libs/gmime:2.6
	dev-libs/json-glib
	dev-libs/libxml2:2
	dev-db/sqlite:3

	daap? ( >=net-libs/libdmapsharing-2.9.12:3.0 )
	dvd? ( >=dev-libs/totem-pl-parser-3.4.1 )
	flickr? ( net-libs/liboauth )
	freebox? ( net-dns/avahi )
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.7.1 )
	lua? ( >=dev-lang/lua-5.2 )
	pocket? (
		dev-libs/json-glib
		>=net-libs/gnome-online-accounts-3.11.4
		>=net-libs/rest-0.7
		>=dev-libs/totem-pl-parser-3.4.1 )
	tracker? ( >=app-misc/tracker-0.10.5:= )
	youtube? (
		>=dev-libs/libgdata-0.9.1
		dev-libs/totem-pl-parser )
	upnp-av? (
		net-libs/gssdp
		>=net-libs/gupnp-0.13
		>=net-libs/gupnp-av-0.5 )
	vimeo? (
		dev-libs/libgcrypt:0
		dev-libs/totem-pl-parser )
"
DEPEND="${RDEPEND}
	app-text/docbook-xml-dtd:4.5
	app-text/yelp-tools
	>=dev-util/intltool-0.40.0
	virtual/pkgconfig
"

src_configure() {
	# --enable-debug only changes CFLAGS, useless for us
	# Plugins
	# shoutcast seems to be broken
	gnome2_src_configure \
		--disable-static \
		--disable-debug \
		--disable-uninstalled \
		--enable-bliptv \
		--enable-apple-trailers \
		--enable-bookmarks \
		--enable-filesystem \
		--enable-gravatar \
		--enable-jamendo \
		--enable-lastfm-albumart \
		--enable-localmetadata \
		--enable-magnatune \
		--enable-metadata-store \
		--enable-podcasts \
		--enable-raitv \
		--disable-shoutcast \
		--enable-tmdb \
		$(use_enable daap dmap) \
		$(use_enable dvd optical-media) \
		$(use_enable flickr) \
		$(use_enable freebox) \
		$(use_enable gnome-online-accounts goa) \
		$(use_enable lua lua-factory) \
		$(use_enable pocket) \
		$(use_enable tracker) \
		$(use_enable upnp-av upnp) \
		$(use_enable vimeo) \
		$(use_enable youtube)
}
