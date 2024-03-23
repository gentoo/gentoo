# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org gnome2-utils meson virtualx xdg

DESCRIPTION="Manage your online calendars with simple and modern interface"
HOMEPAGE="https://wiki.gnome.org/Apps/Calendar"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"

DEPEND="
	>=dev-libs/libical-1.0.1:0=
	>=gnome-base/gsettings-desktop-schemas-3.21.2
	>=gnome-extra/evolution-data-server-3.45.1:=[gtk]
	net-libs/libsoup:3.0
	>=gui-libs/libadwaita-1.4_alpha:1
	>=dev-libs/glib-2.67.5:2
	>=gui-libs/gtk-4.11.2:4
	>=dev-libs/libgweather-4.2.0:4=
	>=app-misc/geoclue-2.4:2.0
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	dev-util/gdbus-codegen
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
