# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9,10} )

inherit meson gnome2-utils python-any-r1 xdg virtualx

DESCRIPTION="Cinnamons's main interface to configure various aspects of the desktop"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/ https://github.com/linuxmint/cinnamon-control-center"
SRC_URI="https://github.com/linuxmint/cinnamon-control-center/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2+ LGPL-2.1+ MIT"
SLOT="0"
IUSE="+colord input_devices_wacom +networkmanager +modemmanager gnome-online-accounts systemd test"
REQUIRED_USE="modemmanager? ( networkmanager )"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
RESTRICT="test"

COMMON_DEPEND="
	>=dev-libs/glib-2.44.0:2
	>=gnome-base/libgnomekbd-3.0.0:0=
	>=gnome-extra/cinnamon-desktop-5.2:0=
	>=gnome-extra/cinnamon-menus-5.2:0=
	media-libs/fontconfig
	>=sys-auth/polkit-0.103
	>=x11-libs/gdk-pixbuf-2.23.0:2
	>=x11-libs/gtk+-3.16.0:3
	>=x11-libs/libnotify-0.7.3:0=
	x11-libs/libX11
	>=x11-libs/libxklavier-5.1

	colord? ( >=x11-misc/colord-0.1.14:0= )
	input_devices_wacom? (
		>=dev-libs/libwacom-0.7:=
		>=gnome-extra/cinnamon-settings-daemon-5.2:0=
		>=x11-libs/libXi-1.2 )
	networkmanager? (
		>=gnome-extra/nm-applet-1.2.0
		>=net-libs/libnma-1.8.34
		>=net-misc/networkmanager-1.2.0:=[modemmanager?]

		modemmanager? ( >=net-misc/modemmanager-0.7 )
	)
	gnome-online-accounts? (
		>=net-libs/gnome-online-accounts-3.18.0
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
	${PYTHON_DEPS}
	dev-util/glib-utils
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

PATCHES=(
	# Fix >=libnma-1.8.34
	# https://github.com/linuxmint/cinnamon-control-center/commit/0f4d212874c4fbee18b860963d0a5c7bd54dcfd1
	"${FILESDIR}"/${PN}-5.2.1-fix-libnma.patch

	# Fix >=libgnomekbd-3.28
	# https://github.com/linuxmint/cinnamon-control-center/commit/8cb73375e66b93da18f7bde728d4a832c07aada4
	"${FILESDIR}"/${PN}-5.2.1-fix-libgnomekbd.patch
)

src_prepare() {
	default
	python_fix_shebang meson_install_schemas.py
}

src_configure() {
	local emesonargs=(
		$(meson_use colord color)
		$(meson_use modemmanager)
		$(meson_use networkmanager)
		$(meson_use gnome-online-accounts onlineaccounts)
		$(meson_use input_devices_wacom wacom)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postinst
	gnome2_schemas_update
}
