# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="A weather application for GNOME"
HOMEPAGE="https://wiki.gnome.org/Design/Apps/Weather"

LICENSE="GPL-2+ LGPL-2+ MIT CC-BY-3.0 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 ~riscv ~x86"

DEPEND="
	>=dev-libs/glib-2.32:2
	>=dev-libs/gobject-introspection-1.56:=
	>=gui-libs/gtk-4.5:4
	>=dev-libs/gjs-1.71.0
	>=app-misc/geoclue-2.3.1:2.0
	>=gui-libs/libadwaita-1.2.0:1=
	>=dev-libs/libgweather-3.90.0:4=
"
RDEPEND="${DEPEND}
	gnome-base/gsettings-desktop-schemas
"
# libxml2 required for glib-compile-resources
BDEPEND="
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

# Tests have a lot of issues, starting with reliance on a system installation,
# accessing the network and other intermittent failures with network-sandbox disabled
# https://gitlab.gnome.org/GNOME/gnome-weather/issues/67 (and rest not filed)
# test dep: $(python_gen_any_dep 'dev-util/dogtail[${PYTHON_USEDEP}]')
# With 3.34, this is now behind a dogtail option we can pass (and have data validation)

src_configure() {
	meson_src_configure -Dprofile=default -Ddogtail=false
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
