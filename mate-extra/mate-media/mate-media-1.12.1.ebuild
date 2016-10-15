# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm x86"
fi

DESCRIPTION="Multimedia related programs for the MATE desktop"
LICENSE="LGPL-2 GPL-2 FDL-1.1"
SLOT="0"

IUSE="gtk3"

RDEPEND=">=dev-libs/glib-2.36.0:2
	dev-libs/libxml2:2
	>=mate-base/mate-panel-1.8[gtk3(-)=]
	>=mate-base/mate-desktop-1.9.3[gtk3(-)=]
	>=media-libs/libmatemixer-1.9.1
	x11-libs/cairo:0
	x11-libs/pango:0
	virtual/libintl:0
	!gtk3? (
		>=dev-libs/libunique-1:1
		>=media-libs/libcanberra-0.13:0[gtk]
		>=x11-libs/gtk+-2.24:2
	)
	gtk3? (
		>=dev-libs/libunique-3:3
		>=media-libs/libcanberra-0.13:0[gtk3]
		>=x11-libs/gtk+-3.0:3
	)"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.0:*
	sys-devel/gettext:*
	virtual/pkgconfig:*
	!!<mate-base/mate-applets-1.8:*"

src_configure() {
	mate_src_configure \
		--with-gtk=$(usex gtk3 3.0 2.0)
}
