# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-dvb/gst-plugins-dvb-1.2.4-r1.ebuild,v 1.7 2014/10/11 12:52:00 maekke Exp $

EAPI="5"

GST_ORG_MODULE=gst-plugins-bad
inherit gstreamer

DESCRIPION="GStreamer plugin to allow capture from dvb devices"
KEYWORDS="alpha amd64 arm ppc ppc64 x86"
IUSE=""

RDEPEND=""
DEPEND="virtual/os-headers"

multilib_src_compile() {
	# Prepare generated headers
	emake -C gst-libs/gst/mpegts

	gstreamer_multilib_src_compile
}
