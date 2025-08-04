# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Remove colored balls from the board by forming lines"
HOMEPAGE="https://gitlab.gnome.org/GNOME/five-or-more"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"

RDEPEND="
	dev-libs/libgee:0.8=
	>=dev-libs/glib-2.32:2
	>=x11-libs/gtk+-3.24:3
	>=dev-libs/libgnome-games-support-1.7.1:1=
	>=gnome-base/librsvg-2.32:2
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(vala_depend)
	gnome-base/librsvg:2[vala]
	dev-libs/appstream
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
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
