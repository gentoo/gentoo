# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson xdg virtualx

DESCRIPTION="Cinnamons's main interface to configure various aspects of the desktop"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/ https://github.com/linuxmint/cinnamon-control-center"
SRC_URI="https://github.com/linuxmint/cinnamon-control-center/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+colord input_devices_wacom +networkmanager +modemmanager systemd test"
REQUIRED_USE="modemmanager? ( networkmanager )"
KEYWORDS="amd64 ~arm64 x86"
RESTRICT="test"

COMMON_DEPEND="
	>=dev-libs/glib-2.44.0:2
	>=gnome-base/libgnomekbd-3.0.0:0=
	>=gnome-extra/cinnamon-desktop-4.8:0=
	>=gnome-extra/cinnamon-menus-4.8:0=
	media-libs/fontconfig
	>=sys-auth/polkit-0.103
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=x11-libs/gtk+-3.16.0:3
	>=x11-libs/libnotify-0.7.3:0=
	x11-libs/libX11
	>=x11-libs/libxklavier-5.1

	colord? ( >=x11-misc/colord-0.1.14:0= )
	input_devices_wacom? (
		>=dev-libs/libwacom-0.7
		>=gnome-extra/cinnamon-settings-daemon-4.8:0=
		>=x11-libs/libXi-1.2 )
	networkmanager? (
		>=gnome-extra/nm-applet-1.2.0
		>=net-misc/networkmanager-1.2.0:=[modemmanager?]

		modemmanager? ( >=net-misc/modemmanager-0.7 )
	)
"
RDEPEND="
	${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme

	colord? ( >=gnome-extra/gnome-color-manager-3 )
	input_devices_wacom? ( gnome-extra/cinnamon-settings-daemon[input_devices_wacom] )
	systemd? ( >=sys-apps/systemd-31 )
	!systemd? ( app-admin/openrc-settingsd )
"
DEPEND="
	${COMMON_DEPEND}
	app-text/iso-codes
	x11-base/xorg-proto
"
BDEPEND="
	dev-util/glib-utils
	>=dev-util/intltool-0.40.1
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

PATCHES=(
	# Fix build when modemmanager is disabled
	# https://github.com/linuxmint/cinnamon-control-center/pull/257
	"${FILESDIR}/${PN}-4.8.2-build-fix.patch"
)

src_configure() {
	local emesonargs=(
		-Donlineaccounts=false
		$(meson_use colord color)
		$(meson_use modemmanager)
		$(meson_use networkmanager)
		$(meson_use input_devices_wacom wacom)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}
