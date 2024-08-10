# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME2_EAUTORECONF="yes"

inherit gnome2

DESCRIPTION="A simple media player written using GStreamer and Clutter"
HOMEPAGE="https://wiki.gnome.org/Apps/Snappy"
COMMIT_HASH="ebf8e3ed30013e6577fa8994db40743d2ec05e94"
SRC_URI="https://gitlab.gnome.org/GNOME/snappy/-/archive/${COMMIT_HASH}/snappy-${COMMIT_HASH}.tar.bz2"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=media-libs/clutter-1.20.0:1.0
	media-libs/clutter-gst:3.0
	>=media-libs/clutter-gtk-1.6.0:1.0
	>=x11-libs/gtk+-3.5.0:3
	x11-libs/libXtst

	>=media-libs/gstreamer-1.6.0:1.0
	>=media-libs/gst-plugins-base-1.6.0:1.0

	media-plugins/gst-plugins-meta:1.0

	!!<net-misc/spice-gtk-0.19
" # File collision -- /usr/bin/snappy with older versions

DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	DOCS="AUTHORS README THANKS ToDo docs/*"
	gnome2_src_configure --enable-dbus
}
