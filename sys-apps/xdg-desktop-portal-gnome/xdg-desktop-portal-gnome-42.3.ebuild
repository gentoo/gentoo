# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org meson systemd xdg

DESCRIPTION="Backend implementation for xdg-desktop-portal using GNOME"
HOMEPAGE="https://gitlab.gnome.org/GNOME/xdg-desktop-portal-gnome"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc ~ppc64 ~riscv x86"
IUSE="wayland X"

BDEPEND="
	dev-util/gdbus-codegen
	sys-devel/gettext
	virtual/pkgconfig
"
DEPEND="
	dev-libs/glib:2
	gnome-base/gnome-desktop:4=
	gui-libs/libadwaita:1
	media-libs/fontconfig
	sys-apps/dbus
	>=sys-apps/xdg-desktop-portal-1.7
	>=sys-apps/xdg-desktop-portal-gtk-1.14.0
	gui-libs/gtk:4[wayland?,X?]
"
RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=(
		-Dsystemduserunitdir="$(systemd_get_userunitdir)"
	)

	meson_src_configure
}
