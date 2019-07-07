# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="GNOME Flashback session"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-flashback/"

LICENSE="GPL-3+"
SLOT="0"
IUSE=""
KEYWORDS="~amd64"

RDEPEND="
	>=x11-libs/gdk-pixbuf-2.32.2:2
	>=x11-libs/gtk+-3.22.0:3[X]
	>=gnome-base/gnome-desktop-3.12.0:3=
	>=media-libs/libcanberra-0.13[gtk3]
	>=dev-libs/glib-2.44.0:2
	>=gnome-base/gsettings-desktop-schemas-3.24.0
	>=sys-auth/polkit-0.97
	>=app-i18n/ibus-1.5.2
	>=sys-power/upower-0.99.0:=
	>=x11-libs/libXrandr-1.5.0
	x11-libs/libxcb
	x11-libs/libX11
	net-wireless/gnome-bluetooth
	x11-libs/libXext
	>=x11-libs/libXi-1.6.0
	x11-libs/pango
	x11-libs/libxkbfile
	x11-misc/xkeyboard-config
	x11-libs/libXfixes
	media-sound/pulseaudio[glib]
"
DEPEND="${RDEPEND}
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	x11-base/xorg-proto
	virtual/pkgconfig
" # autoconf-archive for eautoreconf
RDEPEND="${RDEPEND}
	x11-wm/metacity
	gnome-base/gnome-panel
	gnome-base/gnome-settings-daemon
"

src_configure() {
	gnome2_src_configure \
		--disable-static
}
