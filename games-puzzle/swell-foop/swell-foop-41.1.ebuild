# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Clear the screen by removing groups of colored and shaped tiles"
HOMEPAGE="https://wiki.gnome.org/Apps/Swell%20Foop"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

RDEPEND="
	>=dev-libs/glib-2.36:2
	>=x11-libs/gtk+-3.24:3
	>=media-libs/clutter-1.14.0:1.0
	>=media-libs/clutter-gtk-1.5.0:1.0
	>=dev-libs/libgnome-games-support-1.7.1:1=
	>=dev-libs/libgee-0.14.0:0.8=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/appstream-glib
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
