# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome.org gnome2-utils meson xdg virtualx

DESCRIPTION="GNOME webbrowser based on Webkit"
HOMEPAGE="https://wiki.gnome.org/Apps/Web"

LICENSE="GPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.52.0:2
	>=x11-libs/gtk+-3.22.13:3
	>=dev-libs/nettle-3.2:=
	>=net-libs/webkit-gtk-2.21.92:4=
	>=x11-libs/cairo-1.2
	>=dev-libs/libdazzle-3.28.0
	>=app-crypt/gcr-3.5.5:=[gtk]
	>=x11-libs/gdk-pixbuf-2.36.5:2
	dev-libs/icu:=
	>=app-text/iso-codes-0.35
	>=dev-libs/json-glib-1.2.4
	>=x11-libs/libnotify-0.5.1
	>=app-crypt/libsecret-0.14
	>=net-libs/libsoup-2.48:2.4
	>=dev-libs/libxml2-2.6.12:2
	>=dev-libs/libxslt-1.1.7
	dev-db/sqlite:3
	dev-libs/gmp:0=
	>=gnome-base/gsettings-desktop-schemas-0.0.1
"
RDEPEND="${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme
"
# paxctl needed for bug #407085
# appstream-glib needed for appdata.xml gettext translation
DEPEND="${COMMON_DEPEND}
	dev-libs/appstream-glib
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/itstool
	sys-apps/paxctl
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"

src_configure() {
	local emesonargs=(
		-Ddeveloper_mode=false
		-Ddistributor_name=Gentoo
		-Dtech_preview=false
		$(meson_use test unit_tests)
	)
	meson_src_configure
}

src_test() {
	virtx meson_src_test
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update

	if ! has_version net-libs/webkit-gtk[jpeg2k]; then
		ewarn "Your net-libs/webkit-gtk is built without USE=jpeg2k."
		ewarn "Various image galleries/managers may be broken."
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
