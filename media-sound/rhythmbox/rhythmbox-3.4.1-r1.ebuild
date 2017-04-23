# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python3_{4,5} )
PYTHON_REQ_USE="xml"

inherit eutils gnome2 python-single-r1 multilib virtualx

DESCRIPTION="Music management and playback software for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Rhythmbox"

LICENSE="GPL-2"
SLOT="0"

IUSE="cdr daap dbus gnome-keyring ipod libnotify lirc mtp nsplugin +python test +udev upnp-av visualizer zeitgeist"
REQUIRED_USE="
	ipod? ( udev )
	mtp? ( udev )
	dbus? ( python )
	python? ( ${PYTHON_REQUIRED_USE} )
"

KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.36:2
	>=dev-libs/libxml2-2.7.8:2
	>=x11-libs/gtk+-3.16:3[X,introspection]
	>=x11-libs/gdk-pixbuf-2.18:2
	>=dev-libs/gobject-introspection-0.10:=
	>=dev-libs/libpeas-0.7.3[gtk]
	>=dev-libs/totem-pl-parser-3.2
	>=net-libs/libsoup-2.42:2.4
	>=media-libs/gst-plugins-base-1.4:1.0[introspection]
	>=media-libs/gstreamer-1.4:1.0[introspection]
	>=sys-libs/tdb-1.2.6
	dev-libs/json-glib

	cdr? ( >=app-cdr/brasero-2.91.90 )
	daap? (
		>=net-libs/libdmapsharing-2.9.19:3.0
		>=media-plugins/gst-plugins-soup-1.4:1.0 )
	gnome-keyring? ( >=app-crypt/libsecret-0.18 )
	libnotify? ( >=x11-libs/libnotify-0.7.0 )
	lirc? ( app-misc/lirc )
	python? (
		${PYTHON_DEPS}
		>=dev-python/pygobject-3.0:3[${PYTHON_USEDEP}]
	)
	udev? (
		virtual/libgudev:=
		ipod? ( >=media-libs/libgpod-0.7.92[udev] )
		mtp? ( >=media-libs/libmtp-0.3 ) )
	visualizer? (
		>=media-libs/clutter-1.8:1.0
		>=media-libs/clutter-gst-1.9.92:2.0
		>=media-libs/clutter-gtk-1.0:1.0
		>=x11-libs/mx-1.0.1:1.0
		>=media-plugins/gst-plugins-libvisual-1.4:1.0 )
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
	x11-themes/adwaita-icon-theme
	python? (
		>=dev-libs/libpeas-0.7.3[python,${PYTHON_USEDEP}]
		net-libs/libsoup:2.4[introspection]
		x11-libs/gdk-pixbuf:2[introspection]
		x11-libs/gtk+:3[introspection]
		x11-libs/pango[introspection]

		dbus? ( sys-apps/dbus )
		gnome-keyring? ( >=app-crypt/libsecret-0.18[introspection] ) )
	upnp-av? (
		>=media-libs/grilo-0.3:0.3
		>=media-plugins/grilo-plugins-0.3:0.3[upnp-av] )
"
DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	test? ( dev-libs/check )
"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	DOCS="AUTHORS ChangeLog DOCUMENTERS INTERNALS \
		MAINTAINERS MAINTAINERS.old NEWS README THANKS"

	# https://bugzilla.gnome.org/show_bug.cgi?id=737831
	rm -v lib/rb-marshal.{c,h} || die

	gnome2_src_prepare
}

src_configure() {
	# --enable-vala just installs the sample vala plugin, and the configure
	# checks are broken, so don't enable it
	gnome2_src_configure \
		MOZILLA_PLUGINDIR=/usr/$(get_libdir)/nsbrowser/plugins \
		VALAC=$(type -P true) \
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
		$(use_with gnome-keyring libsecret) \
		$(use_with ipod) \
		$(use_with mtp) \
		$(use_with udev gudev)
}

src_test() {
	unset SESSION_MANAGER
	virtx emake check CK_DEFAULT_TIMEOUT=60
}
