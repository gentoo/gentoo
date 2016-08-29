# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="MATE utilities for netbooks"
LICENSE="GPL-3"
SLOT="0"

IUSE="gtk3"

RDEPEND="
	>=dev-libs/glib-2.36:2
	>=mate-base/mate-desktop-1.9[gtk3(-)=]
	>=mate-base/mate-panel-1.8[gtk3(-)=]
	x11-libs/libfakekey:0
	x11-libs/libXtst:0
	x11-libs/libX11:0
	x11-libs/cairo:0
	virtual/libintl:0
	!gtk3? (
		dev-libs/libunique:1
		x11-libs/gtk+:2
		x11-libs/libwnck:1
	)
	gtk3? (
		dev-libs/libunique:3
		x11-libs/gtk+:3
		x11-libs/libwnck:3
	)"

DEPEND="${RDEPEND}
	x11-proto/xproto:0
	>=dev-util/intltool-0.50.1:*
	sys-devel/gettext:*
	virtual/pkgconfig:*"

src_configure() {
	mate_src_configure \
		--with-gtk=$(usex gtk3 3.0 2.0)
}
