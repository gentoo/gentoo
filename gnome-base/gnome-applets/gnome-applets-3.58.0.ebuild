# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnome2

DESCRIPTION="Applets for the GNOME Flashback Panel"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-applets/"

LICENSE="GPL-2+ FDL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="tracker"

# FIXME: automagic wireless-tools
# TODO: gucharmap could be optional, but no knob
# TODO: libgweather could be optional, but no knob
RDEPEND="
	>=x11-libs/gtk+-3.20.0:3[X]
	>=dev-libs/glib-2.44.0:2
	>=gnome-base/gnome-panel-3.41.1
	>=gnome-base/libgtop-2.11.92:=
	>=x11-libs/libwnck-43.0:3
	>=x11-libs/libnotify-0.7
	>=sys-power/upower-0.99.8:=
	>=x11-themes/adwaita-icon-theme-3.14.0
	>=dev-libs/libxml2-2.5.0:2=
	>=dev-libs/libgweather-4.2.0:4=
	>=gnome-extra/gucharmap-2.33.0:2.90
	>=sys-auth/polkit-0.97
	x11-libs/libX11
	tracker? ( app-misc/tinysparql:3 )
	>=x11-libs/pango-1.50.0
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	app-text/docbook-xml-dtd:4.1.2
	dev-libs/libxslt
	dev-util/gdbus-codegen
	dev-util/glib-utils
	dev-util/itstool
	>=sys-devel/gettext-0.19.6
	virtual/pkgconfig
" # yelp-tools and autoconf-archive for eautoreconf

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable tracker tracker-search-bar)
}
