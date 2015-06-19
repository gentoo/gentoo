# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/marco/marco-1.8.2.ebuild,v 1.1 2014/12/09 00:30:28 tamiko Exp $

EAPI="5"

# Debug only changes CFLAGS
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"

inherit gnome2 versionator

MATE_BRANCH="$(get_version_component_range 1-2)"

SRC_URI="http://pub.mate-desktop.org/releases/${MATE_BRANCH}/${P}.tar.xz"
DESCRIPTION="MATE default window manager"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="startup-notification test xinerama"

RDEPEND="
	dev-libs/atk:0
	>=dev-libs/glib-2.25.10:2
	>=mate-extra/mate-dialogs-1.6:0
	media-libs/libcanberra:0[gtk]
	>=gnome-base/libgtop-2:2=
	x11-libs/cairo:0
	>=x11-libs/pango-1.2:0[X]
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-2.20:2
	x11-libs/libICE:0
	x11-libs/libSM:0
	x11-libs/libX11:0
	>=x11-libs/libXcomposite-0.2:0
	x11-libs/libXcursor:0
	x11-libs/libXdamage:0
	x11-libs/libXext:0
	x11-libs/libXfixes:0
	x11-libs/libXrandr:0
	x11-libs/libXrender:0
	>=x11-libs/startup-notification-0.7:0
	virtual/libintl:0
	xinerama? ( x11-libs/libXinerama:0 )
	!!x11-wm/mate-window-manager"

DEPEND="${RDEPEND}
	app-text/yelp-tools:0
	>=dev-util/intltool-0.34.90:*
	sys-devel/gettext:*
	virtual/pkgconfig:*
	x11-proto/xextproto:0
	x11-proto/xproto:0
	test? ( app-text/docbook-xml-dtd:4.5 )
	xinerama? ( x11-proto/xineramaproto:0 )"

src_configure() {
	gnome2_src_configure \
		--enable-compositor \
		--enable-render \
		--enable-shape \
		--enable-sm \
		--enable-xsync \
		--with-gtk=2.0 \
		$(use_enable startup-notification) \
		$(use_enable xinerama)
}

DOCS="AUTHORS ChangeLog HACKING NEWS README *.txt doc/*.txt"
