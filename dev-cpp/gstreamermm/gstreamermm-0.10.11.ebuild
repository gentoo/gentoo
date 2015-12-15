# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GNOME2_LA_PUNT="yes"

inherit flag-o-matic gnome2

DESCRIPTION="C++ interface for GStreamer"
HOMEPAGE="http://gstreamer.freedesktop.org/bindings/cplusplus.html"

LICENSE="LGPL-2.1"
SLOT="0.10"
KEYWORDS="amd64 ~ppc x86"
IUSE="test"

RDEPEND="
	>=media-libs/gstreamer-0.10.36:0.10
	>=media-libs/gst-plugins-base-0.10.36:0.10
	>=dev-cpp/glibmm-2.33.4:2
	>=dev-cpp/libxmlpp-2.14:2.6
	>=dev-libs/libsigc++-2:2
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? (
		media-libs/gst-plugins-good:0.10
		media-plugins/gst-plugins-vorbis:0.10
		media-plugins/gst-plugins-x:0.10 )
"

# Installs reference docs into /usr/share/doc/gstreamermm-0.10/
# but that's okay, because the rest of dev-cpp/*mm stuff does the same

src_prepare() {
	gnome2_src_prepare
	append-cxxflags -std=c++11 #568254
}
