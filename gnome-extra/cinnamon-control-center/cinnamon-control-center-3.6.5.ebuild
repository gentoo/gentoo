# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
GNOME2_LA_PUNT="yes" # gmodule is used, which uses dlopen

inherit autotools eutils gnome2

DESCRIPTION="Cinnamons's main interface to configure various aspects of the desktop"
HOMEPAGE="http://cinnamon.linuxmint.com/"
SRC_URI="https://github.com/linuxmint/cinnamon-control-center/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+colord +cups debug input_devices_wacom systemd"
KEYWORDS="amd64 ~x86"

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
	>=net-misc/modemmanager-0.7
	>=net-misc/networkmanager-0.9.8:=[modemmanager]
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
	systemd? ( >=sys-apps/systemd-31 )
	!systemd? ( app-admin/openrc-settingsd sys-auth/elogind )
	x11-themes/adwaita-icon-theme
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
	sys-devel/autoconf-archive
"
src_prepare() {
	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	# --enable-systemd doesn't do anything in $PN-2.2.5
	gnome2_src_configure \
		--disable-static \
		--enable-documentation \
		--disable-onlineaccounts \
		$(use_enable colord color) \
		$(use_enable cups) \
		$(usex debug --enable-debug=yes ' ') \
		$(use_enable input_devices_wacom wacom) \
		$(use_enable systemd)
}
