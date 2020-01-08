# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Set of GStreamer elements to ease the creation of non-linear multimedia editors"
HOMEPAGE="http://gnonlin.sourceforge.net"
SRC_URI="https://gstreamer.freedesktop.org/src/${PN}/${P}.tar.xz"

LICENSE="LGPL-2"
SLOT="1.0"
KEYWORDS="amd64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.32:2
	>=media-libs/gstreamer-1.4.0:1.0
	>=media-libs/gst-plugins-base-1.4.0:1.0
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/gtk-doc-am-1.13
	test? (
		dev-libs/check
		>=media-libs/gst-plugins-good-1.4.0:1.0 )
" # videomixer

src_configure() {
	econf --disable-gtk-doc
}

src_install() {
	default
	prune_libtool_files --modules
}
