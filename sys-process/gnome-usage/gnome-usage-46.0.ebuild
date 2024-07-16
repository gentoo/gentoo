# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="A nice way to view information about use of system resources"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-usage"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-libs/libgee-0.8:0.8=
	>=dev-libs/glib-2.74:2
	>=gui-libs/gtk-4.11.3:4
	>=gnome-base/libgtop-2.34.0:2=
	>=gui-libs/libadwaita-1.5:1
	>=app-misc/tracker-3.0.3:3[vala(+)]
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(vala_depend)
	>=sys-devel/gettext-0.19.8
"

src_configure() {
	vala_setup
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
