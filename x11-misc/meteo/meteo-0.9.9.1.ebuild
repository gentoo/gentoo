# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnome2-utils meson vala xdg

DESCRIPTION="Forecast application using OpenWeatherMap API"
HOMEPAGE="https://gitlab.com/bitseater/meteo"
SRC_URI="https://gitlab.com/bitseater/meteo/-/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/libappindicator:3
	dev-libs/glib:2
	dev-libs/json-glib
	net-libs/libsoup:2.4
	net-libs/webkit-gtk:4
	x11-libs/gtk+:3
"
RDEPEND="${DEPEND}
	gnome-base/gsettings-desktop-schemas
	x11-themes/hicolor-icon-theme
"
BDEPEND="
	dev-libs/appstream-glib
	dev-util/intltool
	virtual/pkgconfig
"

src_prepare() {
	default
	vala_src_prepare
}

src_install() {
	meson_src_install
	dosym com.gitlab.bitseater.meteo /usr/bin/meteo
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
