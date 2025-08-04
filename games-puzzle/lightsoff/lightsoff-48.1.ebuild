# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..13} )
inherit gnome.org gnome2-utils meson python-any-r1 xdg vala

DESCRIPTION="Turn off all the lights"
HOMEPAGE="https://gitlab.gnome.org/GNOME/lightsoff"

LICENSE="GPL-2+ CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~x86"

RDEPEND="
	>=dev-libs/glib-2.38.0:2
	>=gui-libs/gtk-4.14.0:4
	>=gui-libs/libadwaita-1.6.0:1
"
DEPEND="${RDEPEND}"
# libxml2:2 needed for glib-compile-resources xml-stripblanks attributes
BDEPEND="
	${PYTHON_DEPS}
	dev-libs/appstream
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	$(vala_depend)
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
