# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="MATE utilities for netbooks"
LICENSE="GPL-3"
SLOT="0"

IUSE=""

COMMON_DEPEND="
	>=dev-libs/glib-2.36:2
	>=mate-base/mate-panel-1.17.0
	>=x11-libs/gtk+-3.14:3
	x11-libs/libfakekey:0
	x11-libs/libwnck:3
	x11-libs/libXtst:0
	x11-libs/libX11:0
	x11-libs/cairo:0
	virtual/libintl:0"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	x11-proto/xproto:0
	>=dev-util/intltool-0.50.1:*
	sys-devel/gettext:*
	virtual/pkgconfig:*"
