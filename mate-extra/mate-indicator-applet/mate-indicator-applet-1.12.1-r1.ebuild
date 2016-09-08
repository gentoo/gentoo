# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit mate versionator

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="MATE indicator applet"
LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"

IUSE="gtk3"

RDEPEND="
	>=mate-base/mate-panel-1.8[gtk3(-)=]
	!gtk3? (
		>=dev-libs/libindicator-0.3.90:0
		>=x11-libs/gtk+-2.24:2
	)
	gtk3? (
		>=dev-libs/libindicator-0.3.90:3
		>=x11-libs/gtk+-3.0:3
	)"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.0
	virtual/pkgconfig"

src_configure() {
	mate_src_configure \
		--with-gtk=$(usex gtk3 3.0 2.0)
}
