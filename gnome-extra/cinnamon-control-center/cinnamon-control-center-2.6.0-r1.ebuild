# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes" # gmodule is used, which uses dlopen

inherit autotools eutils gnome2

DESCRIPTION="Cinnamons's main interface to configure various aspects of the desktop"
HOMEPAGE="http://cinnamon.linuxmint.com/"
SRC_URI="https://github.com/linuxmint/cinnamon-control-center/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~tetromino/distfiles/${PN}/${PN}-2.6.0-pyongyang.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+colord +cups input_devices_wacom"
KEYWORDS="amd64 x86"

# False positives caused by nested configure scripts
QA_CONFIGURE_OPTIONS=".*"

# FIXME: modemmanager is not optional
#        networkmanager is not optional

COMMON_DEPEND="
	>=dev-libs/glib-2.31:2
	dev-libs/libxml2:2
	>=gnome-base/libgnomekbd-2.91.91:0=
	>=gnome-extra/cinnamon-desktop-1.0:0=
	>=gnome-extra/cinnamon-menus-1.0:0=
	>=gnome-extra/cinnamon-settings-daemon-1.0:0=
	>=gnome-extra/nm-applet-0.9.8
	media-libs/fontconfig
	>=media-libs/libcanberra-0.13[gtk3]
	>=media-sound/pulseaudio-1.1[glib]
	>=net-misc/modemmanager-0.7
	>=net-misc/networkmanager-0.9.8[modemmanager]
	>=sys-auth/polkit-0.103
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=x11-libs/gtk+-3.4.1:3
	>=x11-libs/libnotify-0.7.3:0=
	x11-libs/libX11
	x11-libs/libxklavier
	colord? ( >=x11-misc/colord-0.1.14:0= )
	cups? ( >=net-print/cups-1.4[dbus] )
	input_devices_wacom? (
		>=dev-libs/libwacom-0.7
		>=x11-libs/gtk+-3.8:3
		>=x11-libs/libXi-1.2 )
"
# <gnome-color-manager-3.1.2 has file collisions with g-c-c-3.1.x
# libgnomekbd needed only for gkbd-keyboard-display tool
RDEPEND="${COMMON_DEPEND}
	|| ( ( app-admin/openrc-settingsd sys-auth/consolekit ) >=sys-apps/systemd-31 )
	x11-themes/gnome-icon-theme
	x11-themes/gnome-icon-theme-symbolic
	colord? ( >=gnome-extra/gnome-color-manager-3 )
	cups? (
		app-admin/system-config-printer
		net-print/cups-pk-helper )
	input_devices_wacom? ( gnome-extra/cinnamon-settings-daemon[input_devices_wacom] )
"

DEPEND="${COMMON_DEPEND}
	app-text/iso-codes
	x11-proto/xproto
	x11-proto/xf86miscproto
	x11-proto/kbproto

	dev-libs/libxslt
	>=dev-util/intltool-0.40.1
	>=sys-devel/gettext-0.17
	virtual/pkgconfig

	gnome-base/gnome-common

	app-arch/xz-utils
"
# Needed for autoreconf
#	gnome-base/gnome-common

src_prepare() {
	# make some panels optional
	epatch "${FILESDIR}"/${PN}-2.6.0-optional.patch

	# North Korea causes build failure
	cp "${WORKDIR}"/${PN}-2.6.0-pyongyang/*.png panels/datetime/data/ || die
	epatch "${WORKDIR}"/${PN}-2.6.0-pyongyang/*.patch

	epatch_user

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	# --enable-systemd doesn't do anything in $PN-2.2.5
	gnome2_src_configure \
		--disable-static \
		--enable-documentation \
		--without-libsocialweb \
		$(use_enable colord color) \
		$(use_enable cups) \
		$(use_enable input_devices_wacom wacom)
}
