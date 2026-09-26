# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="GNOME Translation Editor"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gtranslator/"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	app-text/libspelling:1
	dev-db/sqlite:3=
	>=dev-libs/glib-2.76:2
	>=gui-libs/gtk-4.12.0:4
	>=gui-libs/libadwaita-1.8_alpha
	gnome-base/gsettings-desktop-schemas
	>=gui-libs/gtksourceview-5.4.0:5
	net-libs/libsoup:3.0
	>=dev-libs/json-glib-1.2.0
	sys-devel/gettext
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-build/meson-1.7
	dev-libs/appstream-glib
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Dprofile=default
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
