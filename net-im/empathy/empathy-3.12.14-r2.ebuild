# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

<<<<<<< HEAD
EAPI=8
PYTHON_COMPAT=( python3_{8..11} )
=======
EAPI=6
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python3_{8..10} )
>>>>>>> 3928948a06b (rebase)

inherit gnome2 python-any-r1 virtualx

DESCRIPTION="Telepathy instant messaging and video/audio call client for GNOME"
HOMEPAGE="https://wiki.gnome.org/Attic/Empathy"

LICENSE="GPL-2 CC-BY-SA-3.0 FDL-1.3 LGPL-2.1"
SLOT="0"
IUSE="debug +geolocation gnome gnome-online-accounts +map spell test +v4l"
RESTRICT="!test? ( test )"
KEYWORDS="amd64 ~arm ~ppc64 x86 ~x86-linux"

# False positives caused by nested configure scripts
QA_CONFIGURE_OPTIONS=".*"

# gdk-pixbuf and pango extensively used in libempathy-gtk
COMMON_DEPEND="
	>=dev-libs/glib-2.48:2[dbus]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.9.4:3
	x11-libs/pango
	>=dev-libs/dbus-glib-0.51
	>=dev-libs/folks-0.9.5:=[telepathy]
	dev-libs/libgee:0.8=
	>=app-crypt/libsecret-0.5
	>=media-libs/libcanberra-0.25[gtk3]
	>=net-libs/webkit-gtk-2.10:4
	>=x11-libs/libnotify-0.7:=

	media-libs/gstreamer:1.0
	>=media-libs/clutter-1.10.0:1.0
	>=media-libs/clutter-gtk-1.1.2:1.0
	media-libs/clutter-gst:3.0
	>=media-libs/cogl-1.14:1.0=

	net-libs/farstream:0.2=
	>=net-libs/telepathy-farstream-0.6.0:=
	>=net-libs/telepathy-glib-0.23.2
	>=net-im/telepathy-logger-0.8.0:=

	app-crypt/gcr:0=[gtk]
	dev-libs/libxml2:2
	gnome-base/gsettings-desktop-schemas
	media-sound/pulseaudio[glib]
	net-libs/libsoup:2.4
	x11-libs/libX11

	geolocation? (
		>=app-misc/geoclue-2.1:2.0
<<<<<<< HEAD
		>=sci-geosciences/geocode-glib-3.10:0 )
=======
		>=sci-geosciences/geocode-glib-3.10 )
>>>>>>> 3928948a06b (rebase)
	gnome-online-accounts? ( >=net-libs/gnome-online-accounts-3.5.1:= )
	map? (
		>=media-libs/clutter-1.7.14:1.0
		>=media-libs/clutter-gtk-0.90.3:1.0
		>=media-libs/libchamplain-0.12.1:0.12[gtk] )
	spell? (
		>=app-text/enchant-1.2:0
		>=app-text/iso-codes-0.35 )
	v4l? (
		dev-libs/libgudev:=
		media-plugins/gst-plugins-v4l2:1.0
		>=media-video/cheese-3.4:= )
"

<<<<<<< HEAD
RDEPEND="${COMMON_DEPEND}
	media-libs/gst-plugins-base:1.0
	net-im/telepathy-connection-managers
=======
# >=empathy-3.4 is incompatible with telepathy-rakia-0.6, bug #403861
RDEPEND="${COMMON_DEPEND}
	media-libs/gst-plugins-base:1.0
	net-im/telepathy-connection-managers
	!<net-voip/telepathy-rakia-0.7
>>>>>>> 3928948a06b (rebase)
	x11-themes/adwaita-icon-theme
	gnome? ( gnome-extra/gnome-contacts )
"
DEPEND="${COMMON_DEPEND}
<<<<<<< HEAD
	test? (
		sys-apps/grep
		>=dev-libs/check-0.9.4 )
"
BDEPEND="
=======
>>>>>>> 3928948a06b (rebase)
	${PYTHON_DEPS}
	dev-libs/libxml2:2
	dev-libs/libxslt
	>=dev-util/intltool-0.50.0
	dev-util/itstool
	virtual/pkgconfig
<<<<<<< HEAD
=======
	test? (
		sys-apps/grep
		>=dev-libs/check-0.9.4 )
>>>>>>> 3928948a06b (rebase)
"
PDEPEND=">=net-im/telepathy-mission-control-5.14"

pkg_setup() {
	python-any-r1_pkg_setup
	export PYTHONIOENCODING=UTF-8 # See bug 489774
}

src_configure() {
	DOCS="CONTRIBUTORS AUTHORS ChangeLog NEWS README"
	gnome2_src_configure \
		--disable-coding-style-checks \
		--disable-static \
		--disable-ubuntu-online-accounts \
		--enable-gst-1.0 \
		$(use_enable debug) \
		$(use_enable geolocation geocode) \
		$(use_enable geolocation location) \
		$(use_enable gnome-online-accounts goa) \
		$(use_enable map) \
		$(use_enable spell) \
		$(use_enable v4l gudev) \
		$(use_with v4l cheese)
}

src_test() {
<<<<<<< HEAD
	virtx dbus-run-session emake check
=======
	dbus-launch virtx emake check #504516
>>>>>>> 3928948a06b (rebase)
}
