# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MATE_LA_PUNT="yes"

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="The MATE Desktop configuration tool"
LICENSE="FDL-1.1+ GPL-2+ LGPL-2+ LGPL-2.1+ HPND"
SLOT="0"

IUSE="accountsservice appindicator debug"

RDEPEND="
	dev-libs/atk
	>=dev-libs/dbus-glib-0.73
	>=dev-libs/glib-2.50:2
	dev-libs/libxml2:2
	>=gnome-base/dconf-0.13.4
	>=gnome-base/librsvg-2.0:2
	>=mate-base/libmatekbd-1.17.0
	>=mate-base/mate-desktop-1.21.2
	>=mate-base/caja-1.20.0
	>=mate-base/mate-menus-1.21.0
	>=mate-base/mate-settings-daemon-1.21.2
	>=media-libs/fontconfig-1:1.0
	media-libs/freetype:2
	media-libs/libcanberra:0[gtk3]
	>=sys-apps/dbus-1
	x11-apps/xmodmap
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXcursor
	x11-libs/libXext
	>=x11-libs/libXi-1.5
	x11-libs/libXrandr
	x11-libs/libXrender
	>=x11-libs/libxklavier-4
	x11-libs/pango
	>=x11-wm/marco-1.17.0:=
	virtual/libintl
	accountsservice? ( sys-apps/accountsservice )
	appindicator? ( dev-libs/libappindicator:3 )"

DEPEND="${RDEPEND}
	app-text/rarian
	>=app-text/scrollkeeper-dtd-1:1.0
	app-text/yelp-tools
	dev-util/desktop-file-utils
	dev-util/glib-utils
	>=dev-util/intltool-0.50.1
	sys-devel/gettext
	x11-base/xorg-proto
	virtual/pkgconfig"

src_configure() {
	mate_src_configure \
		--disable-update-mimedb \
		$(use_enable appindicator) \
		$(use_enable debug)
}
