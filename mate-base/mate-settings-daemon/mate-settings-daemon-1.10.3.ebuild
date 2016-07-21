# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"

inherit eutils gnome2 versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="MATE Settings Daemon"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

IUSE="X debug libnotify policykit pulseaudio smartcard +sound"

REQUIRED_USE="pulseaudio? ( sound )"

RDEPEND=">=dev-libs/dbus-glib-0.74:0
	>=dev-libs/glib-2.17.3:2
	>=gnome-base/dconf-0.13.4:0
	>=mate-base/libmatekbd-1.10:0
	>=mate-base/mate-desktop-1.10:0
	media-libs/fontconfig:1.0
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-2.24:2
	x11-libs/libX11:0
	x11-libs/libXi:0
	x11-libs/libXext:0
	x11-libs/libXxf86misc:0
	>=x11-libs/libxklavier-5:0
	virtual/libintl:0
	libnotify? ( >=x11-libs/libnotify-0.7:0 )
	policykit? (
		>=dev-libs/dbus-glib-0.71:0
		>=sys-apps/dbus-1.1.2:0
		>=sys-auth/polkit-0.97:0
	)
	pulseaudio? (
		media-libs/libcanberra:0[gtk]
		>=media-libs/libmatemixer-1.10:0[pulseaudio]
		>=media-sound/pulseaudio-0.9.15:0
	)
	smartcard? ( >=dev-libs/nss-3.11.2:0 )
	sound? ( >=media-libs/libmatemixer-1.10:0 )"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.37.1:0
	sys-devel/gettext:0
	virtual/pkgconfig:0
	x11-proto/inputproto:0
	x11-proto/xproto:0"

src_configure() {
	gnome2_src_configure \
		$(use_with libnotify) \
		$(use_with sound libmatemixer) \
		$(use_enable debug) \
		$(use_enable policykit polkit) \
		$(use_enable pulseaudio pulse) \
		$(use_enable smartcard smartcard-support) \
		$(use_with X x)
}

DOCS="AUTHORS NEWS ChangeLog"
