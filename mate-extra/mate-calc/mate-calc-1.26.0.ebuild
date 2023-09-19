# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~loong ~riscv x86"
fi

DESCRIPTION="Calculator for MATE"
LICENSE="CC-BY-SA-3.0 GPL-2+"
SLOT="0"

IUSE=""

COMMON_DEPEND="
	>=app-accessibility/at-spi2-core-2.46.0
	>=dev-libs/glib-2.50:2
	dev-libs/libxml2:2
	>=x11-libs/gtk+-3.22:3
	>=dev-libs/mpfr-4.0.2
	x11-libs/pango
"

RDEPEND="${COMMON_DEPEND}
	virtual/libintl
"

BDEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-libs/libxml2
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"
