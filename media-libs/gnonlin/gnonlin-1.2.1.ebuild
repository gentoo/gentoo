# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
inherit gst-plugins10

DESCRIPTION="Gnonlin is a set of GStreamer elements to ease the creation of non-linear multimedia editors"
HOMEPAGE="http://gnonlin.sourceforge.net"

LICENSE="LGPL-2"
SLOT="1.0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-libs/glib-2.34:2
	>=media-libs/gstreamer-1.2:1.0
	>=media-libs/gst-plugins-base-1.2:1.0
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/gtk-doc-am-1.13
	test? (
		dev-libs/check
		>=media-libs/gst-plugins-good-1.2:1.0 )
" # videomixer

src_configure() {
	econf --disable-gtk-doc
}

src_compile() {
	default
}

src_install() {
	default
	prune_libtool_files --all
}
