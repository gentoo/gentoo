# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..14} )

inherit gnome.org gnome2-utils meson python-single-r1 xdg

DESCRIPTION="A library and command-line utility based off of many GNOME Builder components"
HOMEPAGE="https://gitlab.gnome.org/GNOME/foundry"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gtk-doc +sysprof test"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

RDEPEND="
	>=dev-libs/glib-2.82:2
	>=dev-libs/gom-0.5:=
	>=dev-libs/libdex-0.11:=
	>=dev-libs/json-glib-1.8[introspection]
	>=gui-libs/vte-0.80:2.91-gtk4[introspection]
	>=gui-libs/gtksourceview-5.14:5[introspection]
	>=dev-libs/libpeas-2:2[python,${PYTHON_SINGLE_USEDEP}]
	sysprof? (
		>=dev-util/sysprof-45.0[gtk]
	)

	>=dev-libs/gobject-introspection-1.74.0:=
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"

BDEPEND="
	gtk-doc? (
		dev-util/gi-docgen
		app-text/docbook-xml-dtd:4.3
	)
	test? (
		dev-libs/appstream-glib
		sys-apps/dbus
	)
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Ddevelopment=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
