# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

inherit gnome.org gnome2-utils meson python-any-r1 vala virtualx xdg

DESCRIPTION="A lightweight, easy-to-use, feature-rich email client"
HOMEPAGE="https://wiki.gnome.org/Apps/Geary"

LICENSE="LGPL-2.1+ CC-BY-3.0 CC-BY-SA-3.0" # code is LGPL-2.1+, CC licenses for some icons
SLOT="0"
IUSE="test ytnef"
RESTRICT="!test? ( test )"
KEYWORDS="~amd64 ~arm64 ~x86"

# >=gspell-1.7 dep to ensure all libraries used use enchant:2
DEPEND="
	>=dev-libs/glib-2.68:2
	>=x11-libs/gtk+-3.24.23:3
	>=net-libs/webkit-gtk-2.38:4=
	>=dev-libs/gmime-3.2.4:3.0
	>=dev-db/sqlite-3.24:3

	x11-libs/cairo[glib]
	app-text/enchant:2
	>=dev-libs/folks-0.11:0=
	>=app-crypt/gcr-3.10.1:0=
	>=dev-libs/libgee-0.8.5:0.8=
	net-libs/gnome-online-accounts
	media-libs/gsound
	>=app-text/gspell-1.7:=
	>=dev-libs/icu-60:=
	app-text/iso-codes
	>=dev-libs/json-glib-1.0
	>=gui-libs/libhandy-1.2.1:1=
	>=app-crypt/libsecret-0.11
	dev-libs/snowball-stemmer:=
	>=net-libs/libsoup-3.2:3.0
	>=dev-libs/libxml2-2.7.8:2
	ytnef? ( >=net-mail/ytnef-1.9.3 )
"
RDEPEND="${DEPEND}
	gnome-base/gsettings-desktop-schemas
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/appstream-glib-0.7.10
	dev-libs/libxml2
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
	test? ( net-libs/gnutls[tools] )

	$(vala_depend)
	x11-libs/gtk+:3[introspection]
	net-libs/webkit-gtk:4.1[introspection]
	dev-libs/gmime:3.0[vala]
	app-crypt/gcr:0[introspection,vala]
	dev-libs/libgee:0.8[introspection]
	media-libs/gsound[vala]
	app-text/gspell[vala]
	gui-libs/libhandy:1[vala]
	app-crypt/libsecret[introspection,vala]
	net-libs/libsoup:3.0[introspection,vala]
"

src_prepare() {
	vala_setup
	gnome2_environment_reset
	default
}

src_configure() {
	local emesonargs=(
		-Dprofile=release
		-Drevno="${PR}"
		-Dvaladoc=disabled
		-Dcontractor=disabled
		-Dlibunwind=disabled
		$(meson_feature ytnef tnef)
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
