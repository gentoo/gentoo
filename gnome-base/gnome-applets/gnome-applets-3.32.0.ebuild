# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2

DESCRIPTION="Applets for the GNOME Flashback Panel"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-applets/"

LICENSE="GPL-2+ FDL-1.1"
SLOT="0"
IUSE="ipv6 tracker upower"
KEYWORDS="~amd64"

# FIXME: automagic wireless-tools
# TODO: gucharmap could be optional, but no knob
# TODO: libgweather could be optional, but no knob
RDEPEND="
	>=x11-libs/gtk+-3.20.0:3[X]
	>=dev-libs/glib-2.44.0:2
	>=gnome-base/gnome-panel-3.24.1
	>=gnome-base/libgtop-2.11.92:=
	>=x11-libs/libwnck-3.14.1:3
	>=x11-libs/libnotify-0.7
	upower? ( >=sys-power/upower-0.9.4:= )
	>=sys-apps/dbus-1.1.2
	>=dev-libs/dbus-glib-0.74
	>=x11-themes/adwaita-icon-theme-3.14.0
	>=dev-libs/libxml2-2.5.0:2
	>=dev-libs/libgweather-3.28.0:2=
	>=gnome-extra/gucharmap-2.33.0:2.90
	>=sys-auth/polkit-0.97
	x11-libs/libX11
	tracker? ( app-misc/tracker:0/2.0 )
"
# app-text/docbook-sgml-utils for jw binary
DEPEND="${RDEPEND}
	app-text/docbook-sgml-utils
	app-text/docbook-xml-dtd:4.1.2
	dev-libs/libxslt
	dev-util/glib-utils
	>=dev-util/intltool-0.35.0
	dev-util/itstool
	sys-devel/gettext
	x11-base/xorg-proto
	virtual/pkgconfig
" # yelp-tools and autoconf-archive for eautoreconf

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_with upower) \
		--disable-battstat \
		--disable-cpufreq \
		$(use_enable tracker tracker-search-bar) \
		$(use_enable ipv6)
}
