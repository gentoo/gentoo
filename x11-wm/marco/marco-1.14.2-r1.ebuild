# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MATE2_LA_PUNT="yes"

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="MATE default window manager"
LICENSE="GPL-2"
SLOT="0"

IUSE="gtk3 startup-notification test xinerama"

COMMON_DEPEND="
	dev-libs/atk:0
	>=dev-libs/glib-2.32.10:2
	>=gnome-base/libgtop-2:2=
	x11-libs/cairo:0
	>=x11-libs/pango-1.2:0[X]
	x11-libs/gdk-pixbuf:2
	x11-libs/libICE:0
	x11-libs/libSM:0
	x11-libs/libX11:0
	>=x11-libs/libXcomposite-0.3:0
	x11-libs/libXcursor:0
	x11-libs/libXdamage:0
	x11-libs/libXext:0
	x11-libs/libXfixes:0
	x11-libs/libXrandr:0
	x11-libs/libXrender:0
	>=x11-libs/startup-notification-0.7:0
	virtual/libintl:0
	!gtk3? (
		media-libs/libcanberra:0[gtk]
		>=x11-libs/gtk+-2.24:2
	)
	gtk3? (
		media-libs/libcanberra:0[gtk3]
		>=x11-libs/gtk+-3.0:3
	)
	xinerama? ( x11-libs/libXinerama:0 )
	!!x11-wm/mate-window-manager"

RDEPEND="${COMMON_DEPEND}
	gnome-extra/zenity:0
	>=mate-base/mate-desktop-1.9[gtk3(-)=]
"

DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools:0
	>=dev-util/intltool-0.34.90:*
	sys-devel/gettext:*
	virtual/pkgconfig:*
	x11-proto/xextproto:0
	x11-proto/xproto:0
	test? ( app-text/docbook-xml-dtd:4.5 )
	xinerama? ( x11-proto/xineramaproto:0 )"

src_configure() {
	mate_src_configure \
		--enable-compositor \
		--enable-render \
		--enable-shape \
		--enable-sm \
		--enable-xsync \
		--with-gtk=$(usex gtk3 3.0 2.0) \
		$(use_enable startup-notification) \
		$(use_enable xinerama)
}

src_install() {
	mate_src_install
	dodoc {,doc/}*.txt
}
