# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/snappy/snappy-1.0.ebuild,v 1.3 2014/07/23 15:23:23 ago Exp $

EAPI=5
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="A simple media player written using GStreamer and Clutter"
HOMEPAGE="https://wiki.gnome.org/Apps/Snappy"

KEYWORDS="amd64 x86"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=media-libs/clutter-1.12.0:1.0
	>=media-libs/clutter-gst-2.0.0:2.0
	>=media-libs/clutter-gtk-1.0.2:1.0
	>=x11-libs/gtk+-3.5.0:3
	x11-libs/libXtst

	>=media-libs/gstreamer-1.0.0:1.0
	>=media-libs/gst-plugins-base-1.0.0:1.0

	media-plugins/gst-plugins-meta:1.0

	!!net-misc/spice-gtk
" # FIXME: File collision -- /usr/bin/snappy

DEPEND="${RDEPEND}"

src_configure() {
	DOCS="AUTHORS README THANKS ToDo docs/*"
	gnome2_src_configure --enable-dbus
}
