# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="no" # --enable-debug only messes up with FLAGS
PYTHON_COMPAT=( python2_7 )

inherit autotools eutils gnome2 python-single-r1 versionator vcs-snapshot

DESCRIPTION="Helpful utility to attack Repetitive Strain Injury (RSI)"
HOMEPAGE="http://www.workrave.org/"
MY_PV=$(replace_all_version_separators '_')
SRC_URI="https://github.com/rcaelers/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

# dbus support looks to be used only for trying to use panel applets on gnome3!
IUSE="ayatana doc gnome gstreamer introspection mate nls pulseaudio test xfce"
REQUIRED_USE="ayatana? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.28.0:2
	>=x11-libs/gtk+-3.0:3[introspection?]
	>=dev-cpp/gtkmm-3.0.0:3.0
	>=dev-cpp/glibmm-2.28.0:2
	>=dev-libs/libsigc++-2.2.4.2:2
	ayatana? (
		>=dev-libs/libdbusmenu-0.4[gtk3,introspection]
		>=dev-libs/libindicator-0.4:3 )
	gnome? ( >=gnome-base/gnome-shell-3.6.2 )
	gstreamer? (
		media-libs/gstreamer:1.0[introspection?]
		media-libs/gst-plugins-base:1.0[introspection?]
		media-plugins/gst-plugins-meta:1.0 )
	introspection? ( dev-libs/gobject-introspection:= )
	mate? ( mate-base/mate-applets )
	pulseaudio? ( >=media-sound/pulseaudio-0.9.15 )
	xfce? (
		>=x11-libs/gtk+-2.6.0:2[introspection?]
		>=xfce-base/xfce4-panel-4.4 )
	x11-libs/libXScrnSaver
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXtst
	x11-libs/libXt
	x11-libs/libXmu
"
#        dbus? (
#                >=sys-apps/dbus-1.2
#                dev-libs/dbus-glib )

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40.0
	x11-proto/xproto
	x11-proto/inputproto
	x11-proto/recordproto
	dev-python/cheetah
	virtual/pkgconfig
	doc? (
		app-text/docbook-sgml-utils
		app-text/xmlto )
	nls? ( >=sys-devel/gettext-0.17 )
"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_unpack() {
	vcs-snapshot_src_unpack
}

src_prepare() {
	# Fix gstreamer slot automagic dependency, bug #563584
	# http://issues.workrave.org/show_bug.cgi?id=1179
	epatch "${FILESDIR}"/${PN}-1.10.6-automagic-gstreamer.patch
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	# gnet ("distribution") is dead for ages and other distributions stopped
	# relying on it for such time too.
	gnome2_src_configure \
		--disable-dbus \
		--disable-distribution \
		--enable-exercises \
		--disable-experimental \
		--disable-gnome2 \
		--disable-static \
		--disable-xml \
		$(use_enable ayatana indicator) \
		$(use_enable doc manual) \
		$(use_enable gnome gnome3) \
		$(use_enable gstreamer) \
		$(use_enable introspection) \
		$(use_enable mate) \
		$(use_enable nls) \
		$(use_enable pulseaudio pulse) \
		$(use_enable test tests) \
		$(use_enable xfce)
}
