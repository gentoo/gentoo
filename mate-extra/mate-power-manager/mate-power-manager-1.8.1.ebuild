# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

GCONF_DEBUG="no"

inherit autotools gnome2 versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="A session daemon for MATE that makes it easy to manage your laptop or desktop"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="+applet gnome-keyring man policykit test unique"

# Interactive testsuite.
RESTRICT="test"

COMMON_DEPEND="app-text/rarian:0
	>=dev-libs/dbus-glib-0.70:0
	>=dev-libs/glib-2.13:2
	>=media-libs/libcanberra-0.10:0[gtk]
	>=sys-apps/dbus-1:0
	|| ( >=sys-power/upower-0.9.23 >=sys-power/upower-pm-utils-0.9.23 )
	>=x11-apps/xrandr-1.2:0
	>=x11-libs/cairo-1:0
	>=x11-libs/gdk-pixbuf-2.11:2
	>=x11-libs/gtk+-2.17.7:2
	x11-libs/libX11:0
	x11-libs/libXext:0
	x11-libs/libXrandr:0
	>=x11-libs/libnotify-0.7:0
	x11-libs/pango:0
	applet? ( >=mate-base/mate-panel-1.8:0 )
	gnome-keyring? ( >=gnome-base/libgnome-keyring-3:0 )
	unique? ( >=dev-libs/libunique-0.9.4:1 )"

RDEPEND="${COMMON_DEPEND}
	policykit? ( >=mate-extra/mate-polkit-1.8:0 )"

DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.3
	>=app-text/scrollkeeper-dtd-1:1.0
	app-text/yelp-tools:0
	>=dev-util/intltool-0.35:*
	x11-proto/randrproto:0
	>=x11-proto/xproto-7.0.15:0
	sys-devel/gettext:*
	virtual/pkgconfig:*
	man? ( app-text/docbook-sgml-utils:0
		>=app-text/docbook-sgml-dtd-4.3 )"

src_prepare() {
	# Upstreamed patches
	epatch "${FILESDIR}"/${PN}-1.8.0-r1-dbus_interface_keyboard_backlight_controls.patch

	eautoreconf
	gnome2_src_prepare

	# This needs to be after eautoreconf to prevent problems like bug #356277
	# Remove the docbook2man rules here since it's not handled by a proper
	# parameter in configure.in.
	if ! use man; then
		sed -e 's:@HAVE_DOCBOOK2MAN_TRUE@.*::' -i man/Makefile.in \
			|| die "docbook sed failed"
	fi
}

src_configure() {
	gnome2_src_configure \
		$(use_enable applet applets) \
		$(use_enable test tests) \
		$(use_enable unique) \
		$(use_with gnome-keyring keyring) \
		--enable-compile-warnings=minimum \
		--with-gtk=2.0
}

DOCS="AUTHORS HACKING NEWS README TODO"

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS

	dbus-launch Xemake check || die "Test phase failed"
}
