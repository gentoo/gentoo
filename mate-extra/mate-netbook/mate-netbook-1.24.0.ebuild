# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

DESCRIPTION="MATE utilities for netbooks"
LICENSE="LGPL-2+ GPL-3"
SLOT="0"

IUSE=""

COMMON_DEPEND="
	>=dev-libs/glib-2.50:2
	>=mate-base/mate-panel-1.17.0
	>=x11-libs/gtk+-3.22:3
	x11-libs/libfakekey
	x11-libs/libwnck:3
	x11-libs/libXtst
	x11-libs/libX11
	x11-libs/cairo
"

RDEPEND="${COMMON_DEPEND}
	virtual/libintl
"

DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
	>=dev-util/intltool-0.50.1
	>=sys-devel/gettext-0.19.8:*
	virtual/pkgconfig:*
"
