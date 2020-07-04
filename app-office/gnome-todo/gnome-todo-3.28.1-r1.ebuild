# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Personal task manager"
HOMEPAGE="https://wiki.gnome.org/Apps/Todo"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gtk-doc +introspection"

RDEPEND="
	>=dev-libs/glib-2.43.4:2
	>=x11-libs/gtk+-3.22.0:3[introspection?]
	>=net-libs/gnome-online-accounts-3.25.3
	>=dev-libs/libpeas-1.17
	>=gnome-extra/evolution-data-server-3.33.1:=[gtk]
	net-libs/rest:0.7
	dev-libs/json-glib
	introspection? ( >=dev-libs/gobject-introspection-1.42:= )
"
DEPEND="${RDEPEND}
	dev-libs/libxml2:2
	dev-util/glib-utils
	gtk-doc? ( dev-util/gtk-doc
		app-text/docbook-xml-dtd:4.3 )
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/gnome-todo-eds-libecal-2.0.patch
)

src_configure() {
	# TODO: There aren't any consumers of the introspection outside gnome-todo's own plugins, so maybe we
	# TODO: should just always build introspection support as an application that needs it for full functionality?
	# Todoist plugin requires 3.25.3 GOA for being able to add a Todoist account
	local emesonargs=(
		-Dbackground_plugin=true
		-Ddark_theme_plugin=true
		-Dscheduled_panel_plugin=true
		-Dscore_plugin=true
		-Dtoday_panel_plugin=true
		-Dunscheduled_panel_plugin=true
		-Dtodo_txt_plugin=true
		-Dtodoist_plugin=true
		-Dtracing=false
		$(meson_use gtk-doc gtk_doc)
		$(meson_use introspection)
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
