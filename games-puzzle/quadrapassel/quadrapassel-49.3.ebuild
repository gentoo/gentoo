# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Fit falling blocks together"
HOMEPAGE="https://gitlab.gnome.org/GNOME/quadrapassel"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"

RDEPEND="
	dev-libs/libgee:0.8
	>=media-libs/gsound-1.0.2
	>=gui-libs/gtk-4.4:4
	>=gui-libs/libadwaita-1.8:1
	dev-libs/libgnome-games-support:2=
	>=dev-libs/libmanette-0.2.10
	x11-libs/pango
	>=gnome-base/librsvg-2.32.0:2
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/appstream-glib
	dev-util/blueprint-compiler
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	$(vala_depend)
	media-libs/gsound[vala]
	dev-libs/libmanette[vala]
	gnome-base/librsvg:2[vala]
"

src_prepare() {
	default
	vala_setup
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
