# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rhythmbox/rhythmbox-3.1.ebuild,v 1.7 2014/12/19 13:40:46 pacho Exp $

EAPI="5"
GNOME2_LA_PUNT="yes"
GCONF_DEBUG="no"
PYTHON_COMPAT=( python3_{3,4} )
PYTHON_REQ_USE="xml"

inherit eutils gnome2 python-r1 multilib virtualx

DESCRIPTION="Music management and playback software for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Rhythmbox"

LICENSE="GPL-2"
SLOT="0"
IUSE="cdr daap dbus +libsecret html ipod libnotify lirc mtp nsplugin +python
test +udev upnp-av visualizer webkit zeitgeist"

KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"

REQUIRED_USE="
	ipod? ( udev )
	mtp? ( udev )
	dbus? ( python )
	webkit? ( python )
	python? ( ^^ ( $(python_gen_useflags '*') ) )
"

# Tests failing for years without upstream caring at all
# upstream bug #688745
RESTRICT="test"

# FIXME: double check what to do with fm-radio plugin
# webkit-gtk-1.10 is needed because it uses gstreamer-1.0
COMMON_DEPEND="
	>=dev-libs/glib-2.34.0:2
	>=dev-libs/libxml2-2.7.8:2
	>=x11-libs/gtk+-3.6:3[introspection]
	>=x11-libs/gdk-pixbuf-2.18.0:2
	>=dev-libs/gobject-introspection-0.10.0
	>=dev-libs/libpeas-0.7.3[gtk,python?]
	>=dev-libs/totem-pl-parser-3.2.0
	>=net-libs/libsoup-2.34.0:2.4
	media-libs/gst-plugins-base:1.0[introspection]
	media-libs/gstreamer:1.0[introspection]
	>=sys-libs/tdb-1.2.6
	dev-libs/json-glib

	visualizer? (
		>=media-libs/clutter-1.8:1.0
		>=media-libs/clutter-gst-1.9.92:2.0
		>=media-libs/clutter-gtk-1.0:1.0
		>=x11-libs/mx-1.0.1:1.0
		media-plugins/gst-plugins-libvisual:1.0 )
	cdr? ( >=app-cdr/brasero-2.91.90 )
	daap? (
		>=net-libs/libdmapsharing-2.9.19:3.0
		media-plugins/gst-plugins-soup:1.0 )
	libsecret? ( >=app-crypt/libsecret-0.18 )
	html? ( >=net-libs/webkit-gtk-1.10:3 )
	libnotify? ( >=x11-libs/libnotify-0.7.0 )
	lirc? ( app-misc/lirc )
	python? ( >=dev-python/pygobject-3.0:3[${PYTHON_USEDEP}] )
	udev? (
		virtual/libgudev:=
		ipod? ( >=media-libs/libgpod-0.7.92[udev] )
		mtp? ( >=media-libs/libmtp-0.3 ) )
	zeitgeist? ( gnome-extra/zeitgeist )
"
RDEPEND="${COMMON_DEPEND}
	media-plugins/gst-plugins-soup:1.0
	media-plugins/gst-plugins-libmms:1.0
	|| (
		media-plugins/gst-plugins-cdparanoia:1.0
		media-plugins/gst-plugins-cdio:1.0 )
	media-plugins/gst-plugins-meta:1.0
	media-plugins/gst-plugins-taglib:1.0
	x11-themes/gnome-icon-theme-symbolic
	upnp-av? (
		>=media-libs/grilo-0.2:0.2
		>=media-plugins/grilo-plugins-0.2:0.2[upnp-av] )
	python? (
		>=dev-libs/libpeas-0.7.3[${PYTHON_USEDEP}]
		x11-libs/gdk-pixbuf:2[introspection]
		x11-libs/gtk+:3[introspection]
		x11-libs/pango[introspection]

		dbus? ( sys-apps/dbus )
		libsecret? ( >=app-crypt/libsecret-0.18[introspection] )
		webkit? (
			dev-python/mako[${PYTHON_USEDEP}]
			>=net-libs/webkit-gtk-1.10:3[introspection] ) )
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	app-text/yelp-tools
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35
	>=app-text/gnome-doc-utils-0.9.1
	test? ( dev-libs/check )
"

pkg_setup() {
	use python && [[ ${MERGE_TYPE} != binary ]] && python_setup
}

src_prepare() {
	DOCS="AUTHORS ChangeLog DOCUMENTERS INTERNALS \
		MAINTAINERS MAINTAINERS.old NEWS README THANKS"

	rm -v lib/rb-marshal.{c,h} || die # upstream bug 737831

	gnome2_src_prepare
}

src_configure() {
	# FIXME: bug???
	export GST_INSPECT=/bin/true

	# --enable-vala just installs the sample vala plugin, and the configure
	# checks are broken, so don't enable it
	gnome2_src_configure \
		MOZILLA_PLUGINDIR=/usr/$(get_libdir)/nsbrowser/plugins \
		VALAC=$(type -P valac-0.14) \
		--enable-mmkeys \
		--disable-more-warnings \
		--disable-static \
		--disable-vala \
		--without-hal \
		$(use_enable visualizer) \
		$(use_enable daap) \
		$(use_enable libnotify) \
		$(use_enable lirc) \
		$(use_enable nsplugin browser-plugin) \
		$(use_enable python) \
		$(use_enable upnp-av grilo) \
		$(use_with cdr brasero) \
		$(use_with html webkit) \
		$(use_with ipod) \
		$(use_with libsecret) \
		$(use_with mtp) \
		$(use_with udev gudev)
}

src_test() {
	unset SESSION_MANAGER
	unset DBUS_SESSION_BUS_ADDRESS
	Xemake check
}
