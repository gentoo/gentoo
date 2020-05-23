# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils meson xdg-utils

DESCRIPTION="GNOME applet for NetworkManager"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager https://gitlab.gnome.org/GNOME/network-manager-applet"
SRC_URI="https://gitlab.gnome.org/GNOME/network-manager-applet/-/archive/${PV}-dev/network-manager-applet-${PV}-dev.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="appindicator doc introspection lto modemmanager selinux teamd test wwan"

DEPEND="
	app-crypt/libsecret
	app-text/iso-codes
	dev-libs/glib:2[dbus]
	dev-libs/libgudev:=
	net-misc/networkmanager
	x11-libs/gtk+:3[introspection?]
	x11-libs/libnotify
	appindicator? (
		dev-libs/libappindicator:3
		dev-libs/libdbusmenu
	)
	introspection? ( dev-libs/gobject-introspection:= )
	modemmanager? ( net-misc/modemmanager )
	selinux? ( sys-libs/libselinux )
	teamd? ( dev-libs/jansson )
	wwan? ( ~net-misc/networkmanager-1.18.4 )
"
RDEPEND="${DEPEND}"
BDEPEND="doc? ( dev-util/gtk-doc )"

# TODO
RESTRICT="test"

S="${WORKDIR}"/network-manager-applet-${PV}-dev

src_configure() {
	local emesonargs=(
		-Dlibnm_gtk=false
		-Dlibnma_gtk4=false
		$(meson_use appindicator)
		$(meson_use wwan)
		$(meson_use selinux)
		$(meson_use teamd team)
		$(meson_use test gcr)
		-Dmore_asserts=$(usex test 1 0)
		-Diso_codes=true
		$(meson_use modemmanager mobile_broadband_provider_info)
		$(meson_use test ld_gc)
		$(meson_use doc gtk_doc)
		$(meson_use introspection)
		$(meson_use lto b_lto)
	)

	meson_src_configure
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_icon_cache_update
}
