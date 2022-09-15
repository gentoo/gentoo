# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Nibbles clone for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Nibbles https://gitlab.gnome.org/GNOME/gnome-nibbles"

LICENSE="GPL-3+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"

RDEPEND="
	>=dev-libs/glib-2.42.0:2
	>=media-libs/clutter-1.22.0:1.0
	>=media-libs/clutter-gtk-1.4.0:1.0
	dev-libs/libgee:0.8=
	>=media-libs/gsound-1.0.2
	>=x11-libs/gtk+-3.24.0:3
	>=dev-libs/libgnome-games-support-1.7.1:1=
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	$(vala_depend)
	media-libs/gsound[vala]
"

PATCHES=(
	# backport for https://gitlab.gnome.org/GNOME/gnome-nibbles/-/issues/52
	"${FILESDIR}"/${P}-vala-0.50.4-GtkChild-1.patch
	"${FILESDIR}"/${P}-vala-0.50.4-GtkChild-2.patch
)

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
