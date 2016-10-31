# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gnome2

DESCRIPTION="GNOME 3 compositing window manager based on Clutter"
HOMEPAGE="https://git.gnome.org/browse/mutter/"

LICENSE="GPL-2+"
SLOT="0"

IUSE="input_devices_wacom +introspection +kms test udev wayland"
REQUIRED_USE="
	wayland? ( kms )
"

KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

# libXi-1.7.4 or newer needed per:
# https://bugzilla.gnome.org/show_bug.cgi?id=738944
COMMON_DEPEND="
	>=dev-libs/atk-2.5.3
	>=dev-libs/json-glib-0.12.0
	>=x11-libs/pango-1.2[X,introspection?]
	>=x11-libs/cairo-1.10[X]
	>=x11-libs/gtk+-3.19.8:3[X,introspection?]
	>=dev-libs/glib-2.49.0:2[dbus]
	>=media-libs/cogl-1.21.2:1.0=[introspection?]
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/startup-notification-0.7
	>=x11-libs/libXcomposite-0.2
	>=gnome-base/gsettings-desktop-schemas-3.21.4[introspection?]
	gnome-base/gnome-desktop:3=
	>sys-power/upower-0.99:=

	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	>=x11-libs/libXcomposite-0.2
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	>=x11-libs/libXi-1.7.4
	x11-libs/libXinerama
	>=x11-libs/libXrandr-1.5
	x11-libs/libXrender
	x11-libs/libxcb
	x11-libs/libxkbfile
	>=x11-libs/libxkbcommon-0.4.3[X]
	x11-misc/xkeyboard-config

	gnome-extra/zenity

	input_devices_wacom? ( >=dev-libs/libwacom-0.13 )
	introspection? ( >=dev-libs/gobject-introspection-1.42:= )
	kms? (
		>=dev-libs/libinput-1.4
		media-libs/cogl:1.0=[kms]
		>=media-libs/mesa-10.3[gbm]
		sys-apps/systemd
		virtual/libgudev
		x11-libs/libdrm:= )
	udev? ( virtual/libgudev:= )
	wayland? (
		>=dev-libs/wayland-1.6.90
		>=dev-libs/wayland-protocols-1.7
		x11-base/xorg-server[wayland] )
"
DEPEND="${COMMON_DEPEND}
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
	x11-proto/xextproto
	x11-proto/xineramaproto
	x11-proto/xproto
	test? ( app-text/docbook-xml-dtd:4.5 )
"
RDEPEND="${COMMON_DEPEND}
	!x11-misc/expocity
"

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--enable-sm \
		--enable-startup-notification \
		--enable-verbose-mode \
		--with-libcanberra \
		$(use_enable introspection) \
		$(use_enable kms native-backend) \
		$(use_enable wayland) \
		$(use_with input_devices_wacom libwacom) \
		$(use_with udev gudev)
}
