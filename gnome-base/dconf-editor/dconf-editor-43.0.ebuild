# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson vala xdg

DESCRIPTION="Graphical tool for editing the dconf configuration database"
HOMEPAGE="https://gitlab.gnome.org/GNOME/dconf-editor"

LICENSE="GPL-3+"
SLOT="0"

KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x86-linux"

RDEPEND="
	>=gnome-base/dconf-0.26.1
	>=dev-libs/glib-2.55.1:2
	>=x11-libs/gtk+-3.22.27:3
	>=gui-libs/libhandy-1.6.0:1[vala]
"
DEPEND="${RDEPEND}"
BDEPEND="
	$(vala_depend)
	dev-libs/libxml2:2
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
