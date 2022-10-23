# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="An IRC client for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Polari https://gitlab.gnome.org/GNOME/polari"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-libs/glib-2.43.4:2
	net-libs/telepathy-glib[introspection]
	>=dev-libs/gobject-introspection-1.50:=
	>=dev-libs/gjs-1.73.1

	x11-libs/gdk-pixbuf:2[introspection]
	>=app-text/gspell-1.4.0[introspection]
	x11-libs/pango[introspection]
	app-crypt/libsecret[introspection]
	net-libs/libsoup:3.0[introspection]
	net-im/telepathy-logger[introspection]
"
RDEPEND="${DEPEND}
	>=net-irc/telepathy-idle-0.2
"
BDEPEND="
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? (
		dev-libs/json-glib
	)
"

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
