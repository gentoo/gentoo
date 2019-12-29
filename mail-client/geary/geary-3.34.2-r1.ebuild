# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
VALA_MIN_API_VERSION="0.44"

inherit gnome.org gnome2-utils meson vala virtualx xdg

DESCRIPTION="A lightweight, easy-to-use, feature-rich email client"
HOMEPAGE="https://wiki.gnome.org/Apps/Geary"

LICENSE="LGPL-2.1+ BSD-2 CC-BY-3.0 CC-BY-SA-3.0" # code is LGPL-2.1+, BSD-2 for bundled snowball-stemmer, CC licenses for some icons
SLOT="0"

IUSE="ytnef"

KEYWORDS="~amd64"

# for now both enchants work
# FIXME: add valadoc support

# >=webkit-gtk-2.26 dep to ensure HAS_WEBKIT_SHARED_PROC is handled for it.
# If not, it could be compiled against 2.24 and then webkit-gtk upgraded and
# geary not rebuilt, ending up in geary issues #558 and #559 still.
DEPEND="
	>=dev-libs/glib-2.54:2
	>=x11-libs/gtk+-3.24.7:3
	>=net-libs/webkit-gtk-2.26:4=
	>=dev-libs/gmime-2.6.17:2.6
	>=dev-db/sqlite-3.12:3

	>=dev-libs/appstream-glib-0.7.10
	app-text/enchant
	>=dev-libs/folks-0.11:0
	>=app-crypt/gcr-3.10.1:0=
	>=dev-libs/libgee-0.8.5:0.8=
	net-libs/gnome-online-accounts
	app-text/gspell
	app-text/iso-codes
	>=dev-libs/json-glib-1.0
	>=media-libs/libcanberra-0.28
	>=gui-libs/libhandy-0.0.9:0.0=
	>=app-crypt/libsecret-0.11
	>=net-libs/libsoup-2.48:2.4
	>=sys-libs/libunwind-1.1:7
	>=dev-libs/libxml2-2.7.8:2
	ytnef? ( >=net-mail/ytnef-1.9.3 )
"
RDEPEND="${DEPEND}
	gnome-base/gsettings-desktop-schemas
"
BDEPEND="
	dev-util/itstool
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig

	$(vala_depend)
	x11-libs/gtk+:3[introspection]
	net-libs/webkit-gtk:4[introspection]
	app-crypt/gcr:0[introspection,vala]
	dev-libs/libgee:0.8[introspection]
	app-text/gspell[vala]
	app-crypt/libsecret[introspection,vala]
	net-libs/libsoup:2.4[introspection,vala]
"

PATCHES=(
	"${FILESDIR}"/${PV}-fix-ytnef-automagic.patch # https://gitlab.gnome.org/GNOME/geary/merge_requests/390
)

src_prepare() {
	vala_src_prepare
	xdg_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dvaladoc=false
		-Dcontractor=false
		-Dpoodle=true
		-Dlibunwind_optional=false # TODO: Automagical if optional=true
		$(meson_use ytnef tnef-support)
		-Dprofile=default
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
