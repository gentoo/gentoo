# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="The MATE Terminal"
LICENSE="GPL-3"
SLOT="0"

IUSE="gtk3"

COMMON_DEPEND="dev-libs/atk:0
	>=dev-libs/glib-2.36:2
	>=mate-base/mate-desktop-1.6[gtk3(-)=]
	x11-libs/gdk-pixbuf:2
	x11-libs/libICE:0
	x11-libs/libSM:0
	x11-libs/libX11:0
	x11-libs/pango:0
	!gtk3? (
		>=x11-libs/gtk+-2.24.0:2
		>=x11-libs/vte-0.28:0
	)
	gtk3? (
		>=x11-libs/gtk+-3.0:3[X]
		>=x11-libs/vte-0.38:2.91
	)"

RDEPEND="${COMMON_DEPEND}"

DEPEND="${COMMON_DEPEND}
	app-text/rarian:0
	>=app-text/scrollkeeper-dtd-1:1.0
	app-text/yelp-tools:0
	>=dev-util/intltool-0.50.1:*
	sys-devel/gettext:*
	virtual/pkgconfig:*"

src_configure() {
	mate_src_configure \
		--with-gtk=$(usex gtk3 3.0 2.0)
}
