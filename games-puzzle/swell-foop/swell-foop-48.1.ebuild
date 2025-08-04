# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Clear the screen by removing groups of colored and shaped tiles"
HOMEPAGE="https://gitlab.gnome.org/GNOME/swell-foop"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"

RDEPEND="
	>=dev-libs/glib-2.74:2
	>=gui-libs/gtk-4.10:4
	>=gui-libs/libadwaita-1.5:1
	>=dev-libs/libgnome-games-support-2.0.0:2=
	>=gnome-base/librsvg-2.46[vala]
	>=dev-libs/libgee-0.14.0:0.8=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/appstream
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	$(vala_depend)
"

src_prepare() {
	default
	vala_setup
	xdg_environment_reset
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
