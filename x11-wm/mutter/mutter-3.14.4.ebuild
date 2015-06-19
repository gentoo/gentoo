# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/mutter/mutter-3.14.4.ebuild,v 1.1 2015/03/28 09:21:51 pacho Exp $

EAPI="5"
GCONF_DEBUG="yes"

inherit autotools eutils gnome2

DESCRIPTION="GNOME 3 compositing window manager based on Clutter"
HOMEPAGE="http://git.gnome.org/browse/mutter/"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+introspection +kms test wayland"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86"

# libXi-1.7.4 or newer needed per:
# https://bugzilla.gnome.org/show_bug.cgi?id=738944
COMMON_DEPEND="
	>=x11-libs/pango-1.2[X,introspection?]
	>=x11-libs/cairo-1.10[X]
	>=x11-libs/gtk+-3.9.11:3[X,introspection?]
	>=dev-libs/glib-2.36.0:2[dbus]
	>=media-libs/clutter-1.19.5:1.0[introspection?]
	>=media-libs/cogl-1.17.1:1.0=[introspection?]
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/startup-notification-0.7
	>=x11-libs/libXcomposite-0.2
	>=gnome-base/gsettings-desktop-schemas-3.7.3[introspection?]
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
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libxcb
	x11-libs/libxkbfile
	>=x11-libs/libxkbcommon-0.4.3[X]
	x11-misc/xkeyboard-config

	gnome-extra/zenity

	introspection? ( >=dev-libs/gobject-introspection-1.42:= )
	kms? (
		dev-libs/libinput
		>=media-libs/clutter-1.20[egl]
		media-libs/cogl:1.0=[kms]
		>=media-libs/mesa-10.3[gbm]
		sys-apps/systemd
		virtual/libgudev
		x11-libs/libdrm:= )
	wayland? (
		>=dev-libs/wayland-1.5.90
		>=media-libs/clutter-1.20[wayland]
		x11-base/xorg-server[wayland] )
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/gtk-doc-am-1.15
	>=dev-util/intltool-0.41
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/xextproto
	x11-proto/xineramaproto
	x11-proto/xproto
	test? ( app-text/docbook-xml-dtd:4.5 )
"
RDEPEND="${COMMON_DEPEND}
	!x11-misc/expocity
"

src_prepare() {
	# Compat with Ubuntu metacity themes (e.g. x11-themes/light-themes)
	epatch "${FILESDIR}"/${PN}-3.2.1-ignore-shadow-and-padding.patch

	# Automagic fixes, upstream bug #746929
	epatch "${FILESDIR}"/${PN}-3.14.2-automagic.patch

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--enable-sm \
		--enable-startup-notification \
		--enable-verbose-mode \
		--with-libcanberra \
		$(use_enable introspection) \
		$(use_enable kms native-backend) \
		$(use_enable wayland)
}
