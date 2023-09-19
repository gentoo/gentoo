# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~loong ~riscv x86"
fi

DESCRIPTION="The MATE Terminal"
LICENSE="FDL-1.1+ GPL-3+ LGPL-3+"
SLOT="0"

IUSE=""

COMMON_DEPEND="
	>=app-accessibility/at-spi2-core-2.46.0
	>=dev-libs/glib-2.50:2
	>=gnome-base/dconf-0.13.4
	x11-libs/gdk-pixbuf:2
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/pango
	>=x11-libs/gtk+-3.22:3[X]
	>=x11-libs/vte-0.48:2.91
"

RDEPEND="${COMMON_DEPEND}
	>=mate-base/mate-desktop-1.6
	virtual/libintl
"

BDEPEND="${COMMON_DEPEND}
	app-text/rarian
	>=app-text/scrollkeeper-dtd-1:1.0
	app-text/yelp-tools
	dev-util/glib-utils
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"
