# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mate eapi7-ver

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm x86"
fi

DESCRIPTION="MATE indicator applet"
LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"

IUSE=""

COMMON_DEPEND="
	>=dev-libs/libindicator-0.4:3
	>=mate-base/mate-panel-1.17.0
	>=x11-libs/gtk+-3.22:3"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig"
