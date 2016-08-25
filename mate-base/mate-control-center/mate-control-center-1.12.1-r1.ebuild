# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MATE_LA_PUNT="yes"

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="The MATE Desktop configuration tool"
LICENSE="GPL-2"
SLOT="0"

IUSE="appindicator debug gtk3"

RDEPEND="app-text/rarian:0
	dev-libs/atk:0
	>=dev-libs/dbus-glib-0.73:0
	>=dev-libs/glib-2.36:2
	dev-libs/libxml2:2
	>=gnome-base/dconf-0.13.4:0
	>=gnome-base/librsvg-2.0:2
	>=mate-base/libmatekbd-1.6[gtk3(-)=]
	>=mate-base/mate-desktop-1.11[gtk3(-)=]
	>=mate-base/caja-1.8[gtk3(-)=]
	>=mate-base/mate-menus-1.6
	>=mate-base/mate-settings-daemon-1.11[gtk3(-)=]
	>=media-libs/fontconfig-1:1.0
	media-libs/freetype:2
	>=sys-apps/dbus-1:0
	x11-apps/xmodmap:0
	x11-libs/cairo:0
	x11-libs/gdk-pixbuf:2
	x11-libs/libX11:0
	x11-libs/libXScrnSaver:0
	x11-libs/libXcursor:0
	x11-libs/libXext:0
	>=x11-libs/libXi-1.2:0
	x11-libs/libXrandr:0
	x11-libs/libXrender:0
	x11-libs/libXxf86misc:0
	>=x11-libs/libxklavier-4:0
	x11-libs/pango:0
	>=x11-wm/marco-1.9.1[gtk3(-)=]
	virtual/libintl:0
	!gtk3? (
		>=dev-libs/libunique-1:1
		media-libs/libcanberra:0[gtk]
		>=x11-libs/gtk+-2.24:2
		appindicator? ( dev-libs/libappindicator:2 )
	)
	gtk3? (
		>=dev-libs/libunique-3:3
		media-libs/libcanberra:0[gtk3]
		>=x11-libs/gtk+-3.0:3
		appindicator? ( dev-libs/libappindicator:3 )
	)"

DEPEND="${RDEPEND}
	>=app-text/scrollkeeper-dtd-1:1.0
	app-text/yelp-tools:0
	dev-util/desktop-file-utils:0
	>=dev-util/intltool-0.50.1:*
	sys-devel/gettext:*
	x11-proto/kbproto:0
	x11-proto/randrproto:0
	x11-proto/renderproto:0
	x11-proto/scrnsaverproto:0
	x11-proto/xextproto:0
	x11-proto/xf86miscproto:0
	x11-proto/xproto:0
	virtual/pkgconfig:*"

PATCHES=( "${FILESDIR}/${PN}-1.12.1-backport-appindicator-configure.patch" )

src_configure() {
	mate_src_configure \
		--disable-update-mimedb \
		--with-gtk=$(usex gtk3 3.0 2.0) \
		$(use_enable appindicator) \
		$(use_enable debug)
}
