# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="Calculator for MATE"
LICENSE="GPL-2"
SLOT="0"

IUSE=""

COMMON_DEPEND="
	dev-libs/atk:0
	>=dev-libs/glib-2.36:2
	dev-libs/libxml2:2
	>=x11-libs/gtk+-3.14:3
	x11-libs/pango:0"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools:0
	>=dev-util/intltool-0.35.0:*
	sys-devel/gettext:*
	virtual/pkgconfig:*"
