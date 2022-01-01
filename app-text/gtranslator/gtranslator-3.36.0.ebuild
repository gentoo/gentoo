# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="GNOME Translation Editor"
HOMEPAGE="https://wiki.gnome.org/Apps/Gtranslator"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="gtk-doc"

RDEPEND="
	>=dev-libs/glib-2.36.0:2
	>=x11-libs/gtk+-3.22.20:3
	>=dev-libs/libdazzle-3.33.90
	gnome-extra/libgda:5=
	gnome-base/gsettings-desktop-schemas
	>=app-text/gspell-1.2.0:=
	>=x11-libs/gtksourceview-4.0.2:4
	>=dev-libs/libxml2-2.4.12:2
	net-libs/libsoup:2.4
	>=dev-libs/json-glib-1.2.0
"
DEPEND="${RDEPEND}
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	dev-util/glib-utils
	gtk-doc? ( >=dev-util/gtk-doc-1.28
		app-text/docbook-xml-dtd:4.1.2 )
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		$(meson_use gtk-doc gtk_doc)
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
