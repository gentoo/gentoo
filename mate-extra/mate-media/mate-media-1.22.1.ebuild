# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

DESCRIPTION="Multimedia related programs for the MATE desktop"
LICENSE="LGPL-2 GPL-2 FDL-1.1"
SLOT="0"

IUSE=""

COMMON_DEPEND=">=dev-libs/glib-2.50:2
	dev-libs/libxml2:2
	>=mate-base/mate-panel-1.17.0
	>=mate-base/mate-desktop-1.17.0
	>=media-libs/libcanberra-0.13[gtk3]
	>=media-libs/libmatemixer-1.10.0
	x11-libs/cairo
	>=x11-libs/gtk+-3.22:3
	x11-libs/pango
	virtual/libintl"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.35.0
	sys-devel/gettext:*
	virtual/pkgconfig:*
	!!<mate-base/mate-applets-1.8:*"
