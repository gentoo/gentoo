# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-dvb/gst-plugins-dvb-1.4.5.ebuild,v 1.5 2015/03/15 13:36:50 pacho Exp $

EAPI="5"
GST_ORG_MODULE=gst-plugins-bad

inherit gstreamer

DESCRIPION="GStreamer plugin to allow capture from dvb devices"
KEYWORDS="~alpha amd64 ~arm ppc ppc64 x86"
IUSE=""

RDEPEND=""
DEPEND="virtual/os-headers"

multilib_src_compile() {
	# Prepare generated headers
	emake -C gst-libs/gst/mpegts
	gstreamer_multilib_src_compile
}
