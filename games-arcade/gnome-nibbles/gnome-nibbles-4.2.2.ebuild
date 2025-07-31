# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Nibbles clone for GNOME"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-nibbles"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"
RDEPEND="
	>=dev-libs/glib-2.80.0:2
	dev-libs/libgee:0.8=
	>=media-libs/gsound-1.0.2
	>=gui-libs/gtk-4.6:4
	>=gui-libs/libadwaita-1.5:1
	x11-libs/pango
	>=dev-libs/libgnome-games-support-2.0.0:2=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	$(vala_depend)
	media-libs/gsound[vala]
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
