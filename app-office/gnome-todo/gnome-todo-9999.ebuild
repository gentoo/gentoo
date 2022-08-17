# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="Personal task manager"
HOMEPAGE="https://wiki.gnome.org/Apps/Todo https://gitlab.gnome.org/GNOME/gnome-todo"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/gnome-todo.git"
	SRC_URI=""
else
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="+introspection"

RDEPEND="
	>=dev-libs/glib-2.58.0:2
	>=gui-libs/gtk-3.92.0:4[introspection?]
	gui-libs/libadwaita:1
	>=net-libs/gnome-online-accounts-3.25.3
	>=dev-libs/libpeas-1.17
	dev-libs/libportal:0=[gtk]
	>=gnome-extra/evolution-data-server-3.33.2:=[gtk]
	net-libs/rest:0.7
	dev-libs/json-glib
	introspection? ( >=dev-libs/gobject-introspection-1.42:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/libxml2:2
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	# TODO: There aren't any consumers of the introspection outside gnome-todo's own plugins, so maybe we
	# TODO: should just always build introspection support as an application that needs it for full functionality?
	# Todoist plugin requires 3.25.3 GOA for being able to add a Todoist account
	local emesonargs=(
		$(meson_use introspection)
		-Dtracing=false
		-Dprofile=default

		-Dtodo_txt_plugin=true
		-Dtodoist_plugin=true
		-Dunscheduled_panel_plugin=true
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
