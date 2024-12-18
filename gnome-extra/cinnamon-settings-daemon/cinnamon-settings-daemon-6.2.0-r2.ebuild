# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit meson flag-o-matic gnome2-utils python-any-r1 xdg

DESCRIPTION="Cinnamon's settings daemon"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/ https://github.com/linuxmint/cinnamon-settings-daemon"
SRC_URI="https://github.com/linuxmint/cinnamon-settings-daemon/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2+ LGPL-2.1 LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~loong ~ppc64 ~riscv x86"
IUSE="+colord cups input_devices_wacom smartcard systemd wayland"

RDEPEND="
	>=dev-libs/glib-2.40.0:2[dbus]
	dev-libs/libgudev
	>=gnome-base/libgnomekbd-3.6:=
	>=gnome-extra/cinnamon-desktop-6.2:0=
	media-libs/fontconfig
	>=media-libs/lcms-2.2:2
	|| (
		media-libs/libcanberra-gtk3
		media-libs/libcanberra[gtk3(-),pulseaudio]
	)
	>=media-libs/libpulse-0.9.16[glib]
	>=sys-auth/polkit-0.97
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/libnotify-0.7.3
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	>=x11-libs/libxklavier-5.0:=
	>=x11-libs/pango-1.20.0
	>=sys-power/upower-0.9.11:=

	colord? ( >=x11-misc/colord-0.1.27:= )
	cups? (
		>=net-print/cups-1.4[dbus]
		app-admin/system-config-printer
		net-print/cups-pk-helper )
	input_devices_wacom? (
		>=x11-libs/gtk+-3.24.41-r1:3[wayland?,X]
		>=dev-libs/libwacom-0.7:=
		>=gnome-base/librsvg-2.36.2
	)
	!input_devices_wacom? (
		>=x11-libs/gtk+-3.14.0:3
	)
	smartcard? (
		dev-libs/nspr
		>=dev-libs/nss-3.11.2
	)
	systemd? ( sys-apps/systemd:0= )
	!systemd? ( sys-auth/elogind )
"
DEPEND="
	${RDEPEND}
	dev-libs/libxml2:2
	x11-base/xorg-proto
"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/glib-utils
	dev-util/gdbus-codegen
	virtual/pkgconfig
"

src_prepare() {
	default
	python_fix_shebang install-scripts
}

src_configure() {
	# The only component that uses gdk backends is the wacom plugin
	if use input_devices_wacom; then
		# defang automagic dependencies
		use wayland || append-cflags -DGENTOO_GTK_HIDE_WAYLAND
	fi

	# gudev not optional on Linux platforms
	local emesonargs=(
		-Duse_gudev=enabled
		-Duse_polkit=enabled
		-Duse_logind=enabled
		$(meson_feature colord use_color)
		$(meson_feature cups use_cups)
		$(meson_feature smartcard use_smartcard)
		$(meson_feature input_devices_wacom use_wacom)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
