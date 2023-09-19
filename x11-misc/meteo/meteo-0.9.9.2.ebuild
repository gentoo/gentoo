# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
inherit gnome2-utils meson python-any-r1 vala xdg

DESCRIPTION="Forecast application using OpenWeatherMap API"
HOMEPAGE="https://gitlab.com/bitseater/meteo"
SRC_URI="https://gitlab.com/bitseater/meteo/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
# One test needs network (#828052), the other simply checks desktop file
# validation, that we also test with our QA tests
RESTRICT="test"

DEPEND="
	dev-libs/libayatana-appindicator:0
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
BDEPEND="${PYTHON_DEPS}
	dev-libs/appstream-glib
	virtual/pkgconfig
	$(vala_depend)
"

src_configure() {
	vala_setup
	meson_src_configure
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
