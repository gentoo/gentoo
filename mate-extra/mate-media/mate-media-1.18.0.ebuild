# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="Multimedia related programs for the MATE desktop"
LICENSE="LGPL-2 GPL-2 FDL-1.1"
SLOT="0"

IUSE=""

COMMON_DEPEND=">=dev-libs/glib-2.36.0:2
	dev-libs/libxml2:2
	>=mate-base/mate-panel-1.17.0
	>=mate-base/mate-desktop-1.17.0
	>=media-libs/libcanberra-0.13:0[gtk3]
	>=media-libs/libmatemixer-1.10.0
	x11-libs/cairo:0
	>=x11-libs/gtk+-3.14:3
	x11-libs/pango:0
	virtual/libintl:0"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.35.0:*
	sys-devel/gettext:*
	virtual/pkgconfig:*
	!!<mate-base/mate-applets-1.8:*"
