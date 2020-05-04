# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MATE2_LA_PUNT="yes"

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 x86"
fi

DESCRIPTION="MATE default window manager"
LICENSE="FDL-1.2+ GPL-2+ LGPL-2+ MIT"
SLOT="0/2"

IUSE="startup-notification test xinerama"
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-libs/atk
	>=dev-libs/glib-2.50:2
	>=gnome-base/libgtop-2:2=
	media-libs/libcanberra[gtk3]
	x11-libs/cairo
	>=x11-libs/pango-1.2[X]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3.22:3
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	>=x11-libs/libXcomposite-0.3
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXpresent
	x11-libs/libXrandr
	x11-libs/libXrender
	>=x11-libs/startup-notification-0.7
	virtual/libintl
	xinerama? ( x11-libs/libXinerama )
	!!x11-wm/mate-window-manager"

RDEPEND="${COMMON_DEPEND}
	gnome-extra/zenity
	>=mate-base/mate-desktop-1.20.0"

DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	>=dev-util/intltool-0.34.90
	sys-devel/gettext:*
	virtual/pkgconfig:*
	x11-base/xorg-proto
	test? ( app-text/docbook-xml-dtd:4.5 )
	xinerama? ( x11-base/xorg-proto )"

src_configure() {
	mate_src_configure \
		--enable-compositor \
		--enable-render \
		--enable-shape \
		--enable-sm \
		--enable-xsync \
		$(use_enable startup-notification) \
		$(use_enable xinerama)
}

src_install() {
	mate_src_install
	dodoc doc/*.txt
}
