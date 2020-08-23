# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_MIN_API_VERSION="0.44"

inherit gnome.org gnome2-utils meson vala virtualx xdg

DESCRIPTION="A lightweight, easy-to-use, feature-rich email client"
HOMEPAGE="https://wiki.gnome.org/Apps/Geary"

LICENSE="LGPL-2.1+ BSD-2 CC-BY-3.0 CC-BY-SA-3.0" # code is LGPL-2.1+, BSD-2 for bundled snowball-stemmer, CC licenses for some icons
SLOT="0"

IUSE="ytnef"

KEYWORDS="~amd64 ~x86"

# for now both enchants work, but ensuring enchant:2

# >=webkit-gtk-2.26.4-r1 and >=gspell-1.7 dep to ensure all libraries used use enchant:2
DEPEND="
	>=dev-libs/glib-2.60.4:2
	>=x11-libs/gtk+-3.24.7:3
	>=net-libs/webkit-gtk-2.26.4-r1:4=
	>=dev-libs/gmime-3.2.4:3.0
	>=dev-db/sqlite-3.24:3

	app-text/enchant:2
	>=dev-libs/folks-0.11:0
	>=app-crypt/gcr-3.10.1:0=
	>=dev-libs/libgee-0.8.5:0.8=
	net-libs/gnome-online-accounts
	>=app-text/gspell-1.7:=
	app-text/iso-codes
	>=dev-libs/json-glib-1.0
	>=gui-libs/libhandy-0.0.10:0.0=
	>=dev-libs/libpeas-1.24.0
	>=app-crypt/libsecret-0.11
	>=net-libs/libsoup-2.48:2.4
	>=sys-libs/libunwind-1.1:0
	>=dev-libs/libxml2-2.7.8:2
	ytnef? ( >=net-mail/ytnef-1.9.3 )
"
RDEPEND="${DEPEND}
	gnome-base/gsettings-desktop-schemas
"
BDEPEND="
	>=dev-libs/appstream-glib-0.7.10
	dev-libs/libxml2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig

	$(vala_depend)
	x11-libs/gtk+:3[introspection]
	net-libs/webkit-gtk:4[introspection]
	dev-libs/gmime:3.0[vala]
	app-crypt/gcr:0[introspection,vala]
	dev-libs/libgee:0.8[introspection]
	app-text/gspell[vala]
	gui-libs/libhandy:0.0[vala]
	app-crypt/libsecret[introspection,vala]
	net-libs/libsoup:2.4[introspection,vala]
"

src_prepare() {
	vala_src_prepare
	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dcontractor=false
		-Dlibunwind_optional=false # TODO: Automagical if optional=true
		-Dpoodle=true
		$(meson_use ytnef tnef-support)
		-Dvaladoc=false
		-Dprofile=default
		-Drevno="${PR}"
	)

	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
