# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="Calculator for MATE"
LICENSE="CC-BY-SA-3.0 GPL-2+"
SLOT="0"

IUSE=""

COMMON_DEPEND="
	dev-libs/atk
	>=dev-libs/glib-2.50:2
	dev-libs/libxml2:2
	>=x11-libs/gtk+-3.22:3
	x11-libs/pango"

RDEPEND="${COMMON_DEPEND}
	virtual/libintl
"

DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	dev-libs/libxml2
	>=sys-devel/gettext-0.19.8:*
	virtual/pkgconfig:*"
