# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MATE_LA_PUNT="yes"

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm x86"
fi

DESCRIPTION="Utilities for the MATE desktop"
LICENSE="GPL-2"
SLOT="0"

IUSE="X applet debug gtk3 ipv6 test"

RDEPEND="app-text/rarian:0
	dev-libs/atk:0
	>=dev-libs/glib-2.36:2
	>=gnome-base/libgtop-2.12:2=
	sys-libs/zlib:0
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	x11-libs/libICE:0
	x11-libs/libSM:0
	x11-libs/libX11:0
	x11-libs/libXext:0
	x11-libs/pango:0
	applet? ( >=mate-base/mate-panel-1.6[gtk3(-)=] )
	!gtk3? (
		>=x11-libs/gtk+-2.24:2
		>=media-libs/libcanberra-0.4:0[gtk]
	)
	gtk3? (
		>=x11-libs/gtk+-3.0:3
		>=media-libs/libcanberra-0.4:0[gtk3]
	)"

DEPEND="${RDEPEND}
	>=app-text/scrollkeeper-dtd-1:1.0
	app-text/yelp-tools:0
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.50.1:*
	x11-proto/xextproto:0
	sys-devel/gettext:*
	virtual/pkgconfig:*"

PATCHES=( "${FILESDIR}/${P}-dict-gtk3.patch" )

src_prepare() {
	# Make apps visible in all DEs.
	LC_ALL=C find . -iname '*.desktop.in*' -exec \
		sed -e '/OnlyShowIn/d' -i {} + || die

	mate_src_prepare
}

src_configure() {
	mate_src_configure \
		--disable-maintainer-flags \
		--enable-zlib \
		--enable-debug=$(usex debug yes minimum) \
		--with-gtk=$(usex gtk3 3.0 2.0) \
		$(use_with X x) \
		$(use_enable applet gdict-applet) \
		$(use_enable ipv6)
}
