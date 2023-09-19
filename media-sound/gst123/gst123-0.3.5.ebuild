# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="GStreamer based command line media player"
HOMEPAGE="https://space.twc.de/~stefan/gst123.php"
SRC_URI="https://space.twc.de/~stefan/gst123/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="
	dev-libs/glib:2
	media-libs/gst-plugins-base:1.0
	media-libs/gstreamer:1.0
	sys-libs/ncurses:0=
	x11-libs/gtk+:2
	x11-libs/libX11
"
RDEPEND="${CDEPEND}
	media-plugins/gst-plugins-meta:1.0"
DEPEND="${CDEPEND}"
BDEPEND="virtual/pkgconfig"
