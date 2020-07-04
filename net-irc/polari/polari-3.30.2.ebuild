# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome.org gnome2-utils meson xdg

DESCRIPTION="An IRC client for Gnome"
HOMEPAGE="https://wiki.gnome.org/Apps/Polari"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="test"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	>=dev-libs/glib-2.43.4:2
	>=x11-libs/gtk+-3.21.6:3[introspection]
	net-libs/telepathy-glib[introspection]
	>=dev-libs/gobject-introspection-1.50:=
	>=dev-libs/gjs-1.53.90

	x11-libs/gdk-pixbuf:2[introspection]
	>=app-text/gspell-1.4.0[introspection]
	x11-libs/pango[introspection]
	app-crypt/libsecret[introspection]
	net-libs/libsoup:2.4[introspection]
	net-im/telepathy-logger[introspection]
"
RDEPEND="${COMMON_DEPEND}
	>=net-irc/telepathy-idle-0.2
"
DEPEND="${COMMON_DEPEND}
	dev-libs/appstream-glib
	dev-libs/libxml2:2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? ( dev-lang/spidermonkey:60 )
"

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_icon_cache_update
	gnome2_schemas_update
}
