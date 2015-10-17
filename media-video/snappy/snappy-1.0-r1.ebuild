# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
GCONF_DEBUG="no"

inherit autotools eutils gnome2

DESCRIPTION="A simple media player written using GStreamer and Clutter"
HOMEPAGE="https://wiki.gnome.org/Apps/Snappy"

KEYWORDS="~amd64 ~x86"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=media-libs/clutter-1.20.0:1.0
	media-libs/clutter-gst:3.0
	>=media-libs/clutter-gtk-1.6.0:1.0
	>=x11-libs/gtk+-3.5.0:3
	x11-libs/libXtst

	>=media-libs/gstreamer-1.4.0:1.0
	>=media-libs/gst-plugins-base-1.4.0:1.0

	media-plugins/gst-plugins-meta:1.0

	!!<net-misc/spice-gtk-0.19
" # File collision -- /usr/bin/snappy with older versions

DEPEND="${RDEPEND}"

src_prepare() {
	# Fix compat with clutter-1.22 (from 'master')
	epatch "${FILESDIR}"/${P}-clutter-1.22.patch

	# ui: string concatenation to use corect format (from 'master')
	epatch "${FILESDIR}"/${P}-string-concatenation.patch

	# clutter: update method to create video texture (from 'master')
	epatch "${FILESDIR}"/${P}-video-texture.patch

	# Move to clutter-gst-3 (from 'master')
	epatch "${FILESDIR}"/${P}-configure{1,2}.patch
	epatch "${FILESDIR}"/${P}-clutter-gst-3.patch

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	DOCS="AUTHORS README THANKS ToDo docs/*"
	gnome2_src_configure --enable-dbus
}
